USE astro;

-- POGLEDI:
--  pogled 1 koji prikazuje sve dizajnere sa ukupnim brojem eksperimenata u kojim ucestvuju, koliko njih je validno i koliko je izvrseno7
drop view if exists designer_experiment_summary;
create view designer_experiment_summary as
select 
    r.researcher_id,
    r.first_name,
    r.last_name,
    r.qualifications,
    d.method,
    d.field,
    count(distinct e.ex_id) as total_experiments,
    sum(case when e.valid = true then 1 else 0 end) as valid_experiments,
    sum(case when e.done = true then 1 else 0 end) as executed_experiments
from researcher r
join designer d on r.researcher_id = d.designer_id
join designer_experiment de on d.designer_id = de.designer_id
join experiment e on de.ex_id = e.ex_id

group by r.researcher_id, r.first_name, r.last_name, r.qualifications, d.method, d.field
having count(distinct e.ex_id) >= 1
order by total_experiments desc;

-- pogled 2 koji radi sve isto kao i prethodni samo za analiticare
drop view if exists analyst_experiment_summary;
create view analyst_experiment_summary as
select 
    r.researcher_id,
    r.first_name,
    r.last_name,
    r.qualifications,
    a.analyst_role,
    a.av_proc_time,
    count(distinct e.ex_id) as total_experiments,
    sum(case when e.valid = true then 1 else 0 end) as valid_experiments,
    sum(case when e.done = true then 1 else 0 end) as executed_experiments
from researcher r
join analyst a on r.researcher_id = a.anal_id
join analyst_experiment ae on a.anal_id = ae.anal_id
join experiment e on ae.ex_id = e.ex_id

group by r.researcher_id, r.first_name, r.last_name, r.qualifications, a.analyst_role, a.av_proc_time
having count(distinct e.ex_id) >= 1
order by total_experiments desc;

-- pogled 3 koji prikazuje broj opservartorijuma u kojima su resursi gde je kvantna efikasnost preko 75
drop view if exists v_high_performance_observatories;
create view v_high_performance_observatories as 
select 
 o.obs_id,
    o.name_ as observatory_name,
    count(r.res_id) as operational_resource,
    round(avg(r.quantum_efficiency), 2) as avg_quantum_efficiency
from observatory o
join observatory_resource o_r on o.obs_id = o_r.obs_id
join resources r  on o_r.res_id = r.res_id
where r.stat = 'operational'
group by o.obs_id, o.name_
having avg(r.quantum_efficiency) > 75;

-- PROCEDURE:
-- procedura 1 da azurira status izvodjenja u zadati, pod uslovom da se zna session_id i date_start i da je date_end NULL
DROP PROCEDURE IF EXISTS update_execution;
DELIMITER $$
create procedure update_execution (
	in execution_id INT,
	in selected_date DATE,
    in end_stat VARCHAR(30)
) BEGIN
	DECLARE exist INT;
    
    SELECT COUNT(*) INTO exist
    FROM execution 
    WHERE exe_id = execution_id AND exe_date = selected_date;
    
    START TRANSACTION;
    IF exist > 0 THEN
        UPDATE execution
        SET stat = end_stat
        WHERE exe_id = execution_id AND exe_date = selected_date;
    ELSE
        UPDATE execution
        SET stat = 'Unknown'
        WHERE exe_id = execution_id;
    END IF;
    
    COMMIT;
END $$
DELIMITER ;

-- procedura 2 koja zakazuje izvodjenje na osnovu vrednosti validan i izvrsen u eksperimentu
drop procedure if exists schedule_experiment;
DELIMITER $$ 
create procedure schedule_experiment (
	in p_ex_id int,
    in p_title varchar(30),
    in p_desc_ varchar(50),
    in p_valid boolean,
    in p_done boolean,
    in p_obs_id int
) BEGIN
	declare ex_exists int;
    declare exec_exists int;
    declare is_valid boolean;
    declare is_done boolean;
    declare last_exe date;
    
    select count(*) into ex_exists from experiment where ex_id = p_ex_id;
	select count(*) into exec_exists from execution where exe_id = p_ex_id;
    
    start transaction;
    if ex_exists > 0 then
    select valid, done into is_valid, is_done from experiment where ex_id = p_ex_id;
        select exe_date into last_exe from execution where exe_id = p_ex_id order by exe_date desc limit 1;
        
		if (is_valid = false and is_done = true and last_exe is not null and last_exe < date_sub(curdate(), interval 2 year)) or (is_valid = true and is_done = false) then
			if exec_exists > 0 then
				update execution
                set exe_date = curdate(), stat = 'planned'
                where exe_id = p_ex_id;
			else
			insert into execution(exe_id, exe_date, stat) values (p_ex_id, curdate(), 'planned');
			end if;
		update experiment set done = true where ex_id = p_ex_id;
		end if;
	else
		insert into experiment (ex_id, title, desc_, valid, done, obs_id)
		values (p_ex_id, p_title, p_desc_,p_valid, p_done, p_obs_id);
		if exec_exists > 0 then
			update execution
			set exe_date = curdate(), stat = 'planned'
			where exe_id = p_ex_id;
		else 
			insert into execution (exe_id, exe_date, stat) values (p_ex_id, curdate(), 'planned');
		end if;
	update experiment set done = true where ex_id = p_ex_id;
	end if;
    commit;
END $$
DELIMITER ;

-- procedura 3 koja gleda da li sesija za prosledjeni datum i vreme postoji
-- ako postoji, i phase je 1, onda se menja u 2
-- ako postoji i phase je 2, menja se u null, i za date_end i time_end se pise now
-- ako postoji i phase je null, onda se brise
-- ako ne postoji, onda se dodaje novi red u tabelu, i po default-u je zavrsni datum i vreme null, a phase = 1.
-- obs_id i lab_id su tu da se proveri da li je u tim laboratorijama zakazana sesija, onda se ispisuje greska
-- a ako nije zakazana onda moze normalno da se zakazuje.
drop procedure if exists update_session;
DELIMITER $$ 
create procedure update_session (
	in date_ date,
    in time_ time,
    in observatory_id int,
    in laboratory_id int
) BEGIN
    declare s_id int;
    declare p int;
    declare o_id int;
    declare l_id int;
    
    select session_id into s_id from sesion where date_start = date_ and time_start = time_;
    select phase_ into p from sesion where date_start = date_ and time_start = time_;
    
	select session_id into o_id from sesion where obs_id = observatory_id and phase_ is not null limit 1;
	select session_id into l_id from sesion where lab_id = laboratory_id and phase_ is not null limit 1;
    
    start transaction;
		if s_id is null then
			if o_id is null and l_id is null then
				insert into sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) values (date_, time_, NULL, NULL, 1, observatory_id, laboratory_id);
			elseif o_id is not null and l_id is not null then
				select 'There is already a session going on!' as Error1;
			end if;
		elseif s_id is not null then
			if p = 1 then
				-- prelazi u drugu fazu sesije (sesija se prebacuje u laboratoriju)
				update sesion
                set phase_ = 2
                where date_start = date_ and time_start = time_;
			elseif p = 2 then
				-- sesija se zavrsila, phase postaje null
				update sesion
                set phase_ = null,
					date_end = date(now()),
                    time_end = time(now())
                where date_start = date_ and time_start = time_;
			elseif p is null then
				delete from sesion where date_start = date_ and time_start = time_;
			end if;
		end if;
	commit;

END $$
DELIMITER ;


-- procedura 4 za dodavanje novog alata u laboratoriju
drop procedure if exists add_tool;
DELIMITER $$ 
create procedure add_tool (
 in p_tool_id int,
 in p_place_of_prod varchar(40),
 in p_tool_type int,
    in p_lab_id int
) BEGIN
 declare type_exists int;
    declare tool_exists int;
    
    select count(*) into type_exists from tool_type where type_id = p_tool_type;
    select count(*) into tool_exists from tools where tool_id = p_tool_id;
    
    start transaction;
    if type_exists > 0 then
  if tool_exists > 0 then
   update tools
            set place_of_prod = p_place_of_prod, tool_type = p_type_type, lab_id = p_lab_id
            where tool_id = p_tool_id;
  else
   insert into tools(tool_id, place_of_prod, tool_type, lab_id)
   values (p_tool_id, p_place_of_prod, p_tool_type, p_lab_id);
  end if;
    end if;
    commit;
END $$
DELIMITER ;

-- procedura 5 za dodavanje novog resursa u opservartorijum
-- ukoliko se uneti id poklapa sa vec postojecim, onda se updateuje resurs u prosledjeni
drop procedure if exists add_resource;
DELIMITER $$ 
create procedure add_resource (
 in p_res_id int,
 in p_title varchar(20),
    in p_description_ varchar(50),
    in p_stat varchar(15),
    in p_last_repair_date date,
    in p_quantum_efficiency int,
    in p_obs_id int
) BEGIN
 declare res_exists int;
    declare obs_exists int;
    
    select count(*) into res_exists from resources where res_id = p_res_id;
    select count(*) into obs_exists from observatory where obs_id = p_obs_id;
    
    start transaction;
    if obs_exists > 0 then
  if res_exists > 0 then
   update resources
            set title = p_title,
    description_ = p_description_,
    stat = p_stat,
    last_repair_date = p_last_repair_date,
    quantum_efficiency = p_quantum_efficiency
            where res_id = p_res_id;
  else 
   insert into resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency)
            values (p_res_id, p_title, p_description_, p_stat, p_last_repair_date, p_quantum_efficiency);
            
            insert into observatory_resource (obs_id, res_id)
            values (p_obs_id, p_res_id);
  end if;
 end if;
    
    commit;
END $$
DELIMITER ;

-- procedura 6 koja, po zavrsetku eksperimenta, brise svoje dizajnere i analiticare
drop procedure if exists delete_researcher;
DELIMITER $$
CREATE PROCEDURE delete_researcher (
    IN exe_id INT
)
BEGIN
    DECLARE v_done TINYINT(1);
    
    SELECT done INTO v_done
    FROM experiment
    WHERE ex_id = exe_id;
	
    START TRANSACTION;
		IF v_done = TRUE THEN
			DELETE FROM analyst_experiment
			WHERE ex_id = exe_id;

			DELETE FROM designer_experiment
			WHERE ex_id = exe_id;
		END IF;
	COMMIT;
END $$
DELIMITER ;

-- FUNKCIJE:
-- funkcija 1 koja preko id istrazivaca vraca da li je on 'dizajner', 'izvodjac' ili 'analiticar'
drop function if exists researcher_type;
DELIMITER $$
create function researcher_type(
	r_id int
) returns varchar(30)
BEGIN
	declare d_id int;
    declare e_id int;
    declare a_id int;
    
    declare d varchar(30);
    declare e varchar(30);
    declare a varchar(30);
    
    set d = 'Designer';
    set e = 'Executer';
    set a = 'Analyst';
    
    select designer_id into d_id from designer where r_id = designer_id;
    select executer_id into e_id from executer where r_id = executer_id;
	select anal_id into a_id from analyst where r_id = anal_id;
    
    if d_id is not null then
		return d;
    elseif e_id is not null then
		return e;
	elseif a_id is not null then
		return a;
	end if;
    
    return 'Unknown';
END $$
DELIMITER ;

drop function if exists researcher_type_tester;
DELIMITER $$
create function researcher_type_tester()
returns boolean
BEGIN
	declare res varchar(30);
    
    set res	= researcher_type(67);
    if res != 'Designer' then return false; end if;
    
    set res	= researcher_type(83);
    if res != 'Designer' then return false; end if;
    
    set res	= researcher_type(172);
    if res != 'Executer' then return false; end if;
    
    set res	= researcher_type(294);
    if res != 'Analyst' then return false; end if;
    
    set res	= researcher_type(451);
    if res != 'Unknown' then return false; end if;
    
    return true;
END $$
DELIMITER ;

-- funkcija 2 koja vraca koliko ispravnih resursa ima prosledjeni opservartorijum, i ako joj je prosledjeno 1
-- ako joj je prosledjeno 0, vraca broj pokvarenih resursa
-- ako joj je prosledjeno 2, onda broj svih resursa
drop function if exists resources_num;
DELIMITER $$
CREATE FUNCTION resources_num(
    obs_id INT,
    criteria INT
)
RETURNS INT
BEGIN
    DECLARE resource_num INT;

    IF criteria = 1 THEN
        SELECT COUNT(*) INTO resource_num
        FROM observatory_resource orr
        JOIN resources r ON orr.res_id = r.res_id
        WHERE orr.obs_id = p_obs_id AND r.stat = 'operational';

    ELSEIF criteria = 0 THEN
        SELECT COUNT(*) INTO resource_num
        FROM observatory_resource orr
        JOIN resources r ON orr.res_id = r.res_id
        WHERE orr.obs_id = p_obs_id AND r.stat = 'offline';

    ELSEIF criteria = 2 THEN
        SELECT COUNT(*) INTO resource_num
        FROM observatory_resource
        WHERE obs_id = p_obs_id;

    ELSE
        SET resource_num = 0;
    END IF;

    RETURN resource_num;
END $$
DELIMITER ;

-- tester funkcija za resources_num
drop function if exists resources_num_tester;
DELIMITER $$
create function resources_num_tester()
		returns boolean
BEGIN
	if resources_num(1, 1) < 0 then return false;
    end if;
    if resources_num(1, 0) < 0 then return false;
    end if;
    if resources_num(1, 2) < resources_num(1, 1) then return false;
    end if;
    if resources_num(9999, 1) != 0 then return false; 
    end if;
    if resources_num(1, 99) != 0 then return false;
    end if;
    
    return true;
END $$
DELIMITER ;

-- funkcija 3 koja za prosledjeni broj godina vraca broj istrazivaca koji imaju taj broj godina
DELIMITER $$
CREATE FUNCTION researcher_age_count(
    age INT
)
RETURNS INT
BEGIN
    DECLARE counter INT;

    SELECT COUNT(*) INTO counter
    FROM researcher
    WHERE TIMESTAMPDIFF(YEAR, dob, CURDATE()) = age;

    RETURN counter;
END $$
DELIMITER ;

-- tester funkcija za researcher_age_count
drop function if exists researcher_age_count_tester;
DELIMITER $$
create function researcher_age_count_tester() returns boolean
BEGIN
	if researcher_age_count(30) < 0 then return false;
    end if;
    if researcher_age_count(25) < 0 then return false;
    end if;
    if researcher_age_count(-5) != 0 then return false;
    end if;
    if researcher_age_count(300) != 0 then return false;
    end if;
    if researcher_age_count(40) > (select count(*) from researcher) then return false;
    end if;
    
    return true;
END $$
DELIMITER ;

-- funkcija 4 koja vraca procenat uspesno izvrsenih izvodjenja
drop function if exists execution_stat_s;
DELIMITER $$
create function execution_stat_s() returns float
BEGIN
declare total_count int;
declare success_count int;
declare result_per_s float;

select count(*) into total_count from execution;
select count(*) into success_count from execution where stat = 'completed successfully';

if total_count = 0 then
 set result_per_s = 0;
else
 set result_per_s = round((success_count * 100) / total_count, 2);
end if;

 return result_per_s;
END $$
DELIMITER ;

-- tester funkcija za execution_stat_s;
drop function if exists	execution_stat_s_tester;
DELIMITER $$
create function execution_stat_s_tester() returns boolean
BEGIN
	declare res float;
	set result = execution_stat_s();
	if res < 0 or res > 100 then return false;
    end if;
    if execution_stat_s() != execution_stat_s() then return false;
    end if;
    if execution_stat_s() + execution_stat_us() > 100 then return false;
    end if;
    if (select count(*) from execution) = 0 and res != 0 then return false;
    end if;
    if res != round(res, 2) then return false;
    end if;
    
    return true;
END $$
DELIMITER ;

-- funkcija 5 koja vraca procenat neuspesno izvrsenih izvodjenja
drop function if exists execution_stat_us;
DELIMITER $$
create function execution_stat_us() returns float
BEGIN
declare total_count int;
declare unsuccess_count int;
declare result_per_us float;


select count(*) into total_count from execution;
select count(*) into unsuccess_count from execution where stat = 'completed unsuccessfully';


if total_count = 0 then
    set result_per_us = 0;
else
 set result_per_us = round((unsuccess_count * 100) / total_count, 2);
end if;

 return result_per_us;
END $$
DELIMITER ;

-- tester funkcija za execution_stat_us
drop function if exists execution_stat_us_tester;
DELIMITER $$
create function execution_stat_us_tester() return boolean
BEGIN
	declare res float;
    set res = execution_stat_us();
    if res < 0 or res > 0 then return false;
    end if;
    if execution_stat_us() != execution_stat_us() then return false;
    end if;
    if execution_stat_s() + execution_stat_us() > 100 then return false;
    end if;
    if (select count(*) from execution) = 0 and res != 0 then return false;
    end if;
    if res != round(res, 2) then return false;
    end if;
    
    return true;
END $$
DELIMITER ;