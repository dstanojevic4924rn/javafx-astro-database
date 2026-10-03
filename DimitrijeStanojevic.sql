use astro;

select
	o.obs_id,
    o.name_ as observatory_name,
    count(e.exe_id) as ukupno_izvrsenja
from observatory o
join experiment ex on o.obs_id = ex.obs_id
join execution e on ex.ex_id = e.exe_id
group by o.obs_id, o.name_
having ukupno_izvrsenja >= 1
order by ukupno_izvrsenja desc;

