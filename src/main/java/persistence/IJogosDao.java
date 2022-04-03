package persistence;

import java.sql.SQLException;
import java.util.List;

import model.Jogo;

public interface IJogosDao {

	public String gerarJogos() throws SQLException, ClassNotFoundException;
	public List<Jogo> listarJogos(String data) throws SQLException, ClassNotFoundException;
}
