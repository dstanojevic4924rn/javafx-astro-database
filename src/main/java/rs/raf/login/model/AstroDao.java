package rs.raf.login.model;

import rs.raf.login.Config;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AstroDao {

    public static List<String[]> getAllResearchLabs(Connection conn) {
        List<String[]> labs = new ArrayList<>();
        String sql = "SELECT lab_id, name_, location, capacity FROM research_lab ORDER BY lab_id";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                labs.add(new String[]{
                        String.valueOf(rs.getInt("lab_id")),
                        rs.getString("name_"),
                        rs.getString("location"),
                        String.valueOf(rs.getInt("capacity"))
                });
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return labs;
    }

    public static List<String[]> getResearchersByLab(Connection conn, int labId) {
        List<String[]> researchers = new ArrayList<>();
        String sql = "SELECT DISTINCT r.researcher_id, r.first_name, r.last_name, r.dob, r.qualifications, r.ablities " +
                "FROM researcher r " +
                "INNER JOIN designer d ON r.researcher_id = d.designer_id " +
                "INNER JOIN sesion s ON d.obs_id = s.obs_id " +
                "WHERE s.lab_id = ? " +
                "ORDER BY r.researcher_id";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, labId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                researchers.add(new String[]{
                        String.valueOf(rs.getInt("researcher_id")),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("dob"),
                        rs.getString("qualifications"),
                        rs.getString("ablities")
                });
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return researchers;
    }

    public static List<String[]> getAllResearchers(Connection conn) {
        List<String[]> researchers = new ArrayList<>();
        String sql = "SELECT researcher_id, first_name, last_name, dob, qualifications, ablities FROM researcher ORDER BY researcher_id";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                researchers.add(new String[]{
                        String.valueOf(rs.getInt("researcher_id")),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("dob"),
                        rs.getString("qualifications"),
                        rs.getString("ablities")
                });
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return researchers;
    }

    public static String[] getResearcherById(Connection conn, int researcherId) {
        String sql = "SELECT researcher_id, first_name, last_name, dob, qualifications, ablities " +
                "FROM researcher WHERE researcher_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, researcherId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new String[]{
                        String.valueOf(rs.getInt("researcher_id")),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("dob"),
                        rs.getString("qualifications"),
                        rs.getString("ablities")
                };
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public static String[] getDesignerInfo(Connection conn, int researcherId) {
        String sql = "SELECT d.method, d.average_rating, d.field, o.name_ as obs_name " +
                "FROM designer d " +
                "LEFT JOIN observatory o ON d.obs_id = o.obs_id " +
                "WHERE d.designer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, researcherId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new String[]{
                        rs.getString("method"),
                        String.valueOf(rs.getDouble("average_rating")),
                        rs.getString("field"),
                        rs.getString("obs_name")
                };
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public static String[] getAnalystInfo(Connection conn, int researcherId) {
        String sql = "SELECT a.analyst_role, a.av_proc_time, l.name_ as lab_name " +
                "FROM analyst a " +
                "LEFT JOIN research_lab l ON a.lab_id = l.lab_id " +
                "WHERE a.anal_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, researcherId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new String[]{
                        rs.getString("analyst_role"),
                        String.valueOf(rs.getInt("av_proc_time")),
                        rs.getString("lab_name")
                };
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public static String[] getExecuterInfo(Connection conn, int researcherId) {
        String sql = "SELECT e.title, e.expertise, e.work_hours, ex.stat as exe_stat " +
                "FROM executer e " +
                "LEFT JOIN execution ex ON e.exe_id = ex.exe_id " +
                "WHERE e.executer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, researcherId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new String[]{
                        rs.getString("title"),
                        rs.getString("expertise"),
                        String.valueOf(rs.getInt("work_hours")),
                        rs.getString("exe_stat")
                };
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public static List<String[]> getExperimentsByDesigner(Connection conn, int researcherId) {
        List<String[]> experiments = new ArrayList<>();
        String sql = "SELECT e.ex_id, e.title, e.desc_, e.valid, e.done, o.name_ as obs_name " +
                "FROM experiment e " +
                "INNER JOIN designer_experiment de ON e.ex_id = de.ex_id " +
                "LEFT JOIN observatory o ON e.obs_id = o.obs_id " +
                "WHERE de.designer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, researcherId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                experiments.add(new String[]{
                        String.valueOf(rs.getInt("ex_id")),
                        rs.getString("title"),
                        rs.getString("desc_"),
                        String.valueOf(rs.getBoolean("valid")),
                        String.valueOf(rs.getBoolean("done")),
                        rs.getString("obs_name")
                });
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return experiments;
    }

    public static List<String[]> getExperimentsByAnalyst(Connection conn, int researcherId) {
        List<String[]> experiments = new ArrayList<>();
        String sql = "SELECT e.ex_id, e.title, e.desc_, e.valid, e.done, o.name_ as obs_name " +
                "FROM experiment e " +
                "INNER JOIN analyst_experiment ae ON e.ex_id = ae.ex_id " +
                "LEFT JOIN observatory o ON e.obs_id = o.obs_id " +
                "WHERE ae.anal_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, researcherId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                experiments.add(new String[]{
                        String.valueOf(rs.getInt("ex_id")),
                        rs.getString("title"),
                        rs.getString("desc_"),
                        String.valueOf(rs.getBoolean("valid")),
                        String.valueOf(rs.getBoolean("done")),
                        rs.getString("obs_name")
                });
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return experiments;
    }

    public static List<String[]> getTheoriesByDesigner(Connection conn, int researcherId) {
        List<String[]> theories = new ArrayList<>();
        String sql = "SELECT t.theory_id, t.name_, t.description_ " +
                "FROM theory t " +
                "INNER JOIN theory_designer td ON t.theory_id = td.theory_id " +
                "WHERE td.designer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, researcherId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                theories.add(new String[]{
                        String.valueOf(rs.getInt("theory_id")),
                        rs.getString("name_"),
                        rs.getString("description_")
                });
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return theories;
    }

    public static List<String[]> getSessionsByDesigner(Connection conn, int researcherId) {
        List<String[]> sessions = new ArrayList<>();
        String sql = "SELECT s.session_id, s.date_start, s.time_start, s.date_end, s.time_end, " +
                "s.phase_, l.name_ as lab_name, o.name_ as obs_name " +
                "FROM sesion s " +
                "INNER JOIN designer d ON s.obs_id = d.obs_id " +
                "LEFT JOIN research_lab l ON s.lab_id = l.lab_id " +
                "LEFT JOIN observatory o ON s.obs_id = o.obs_id " +
                "WHERE d.designer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, researcherId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                sessions.add(new String[]{
                        String.valueOf(rs.getInt("session_id")),
                        rs.getString("date_start"),
                        rs.getString("time_start"),
                        rs.getString("date_end"),
                        rs.getString("time_end"),
                        String.valueOf(rs.getInt("phase_")),
                        rs.getString("lab_name"),
                        rs.getString("obs_name")
                });
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return sessions;
    }

    public static String getLabNameForResearcher(Connection conn, int researcherId) {
        String sql = "SELECT DISTINCT l.name_ " +
                "FROM research_lab l " +
                "INNER JOIN sesion s ON l.lab_id = s.lab_id " +
                "INNER JOIN designer d ON s.obs_id = d.obs_id " +
                "WHERE d.designer_id = ? LIMIT 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, researcherId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("name_");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }
}
