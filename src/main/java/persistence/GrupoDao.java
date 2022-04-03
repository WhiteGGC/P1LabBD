package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Grupo;
import model.Time;

public class GrupoDao implements IGrupoDao {

	private GenericDao gDao;

	public GrupoDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public String geraGrupos() throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();

		String sql = "CALL sp_gerador_grupos";
		CallableStatement cs = c.prepareCall(sql);
		cs.execute();
		
		String saida = "Novos grupos gerados!";
		
		cs.close();
		c.close();
		return saida;
	}

	@Override
	public List<Grupo> listarGrupos() throws SQLException, ClassNotFoundException {
		List<Grupo> grupos = new ArrayList<Grupo>();
		
		Connection c = gDao.getConnection();
		String sql = "SELECT * FROM v_grupos_times ORDER BY Grupo";
		
		PreparedStatement ps = c.prepareStatement(sql.toString());

		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Time t = new Time();
			t.setNomeTime(rs.getString("Time"));
			t.setCidade(rs.getString("cidade"));
			t.setEstadio(rs.getString("estadio"));
			
			Grupo g = new Grupo();
			g.setTime(t);
			g.setGrupo(rs.getString("Grupo"));
			
			grupos.add(g);
		}
		
		rs.close();
		ps.close();
		c.close();
		
		return grupos;
	}
	
	@Override
	public List<Grupo> listarGrupo (String letra) throws SQLException, ClassNotFoundException {
		List<Grupo> grupos = new ArrayList<Grupo>();
		
		Connection c = gDao.getConnection();
		String sql = "SELECT * FROM v_grupos_times WHERE Grupo = ? ORDER BY Grupo";
		
		PreparedStatement ps = c.prepareStatement(sql.toString());
		ps.setString(1, letra);

		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Time t = new Time();
			t.setNomeTime(rs.getString("Time"));
			t.setCidade(rs.getString("cidade"));
			t.setEstadio(rs.getString("estadio"));
			
			Grupo g = new Grupo();
			g.setTime(t);
			g.setGrupo(rs.getString("Grupo"));
			
			grupos.add(g);
		}
		
		rs.close();
		ps.close();
		c.close();
		
		return grupos;
	}

}
