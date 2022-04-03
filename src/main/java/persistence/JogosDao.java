package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import model.Jogo;

public class JogosDao implements IJogosDao {

	private GenericDao gDao;

	public JogosDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public String gerarJogos() throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();

		String sql = "CALL sp_gerador_jogos";
		CallableStatement cs = c.prepareCall(sql);
		cs.execute();
		
		String saida = "Novos jogos gerados!";
		
		cs.close();
		c.close();
		return saida;
	}

	@Override
	public List<Jogo> listarJogos(String data) throws SQLException, ClassNotFoundException {
		List<Jogo> jogos = new ArrayList<Jogo>();

		Connection c = gDao.getConnection();
		String sql = "SELECT * FROM v_jogos WHERE Data = ? ORDER BY Data";
		
		PreparedStatement ps = c.prepareStatement(sql.toString());
		ps.setString(1, data);

		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Jogo j = new Jogo();
			j.setTimeA(rs.getString("NomeTime A"));
			j.setTimeB(rs.getString("NomeTime B"));
			j.setGolsTimeA(rs.getInt("GolsTimeA"));
			j.setGolsTimeB(rs.getInt("GolsTimeB"));
			j.setData(rs.getString("Data"));

			jogos.add(j);
		}
		return jogos;
	}

}
