package model;

public class Time {
	private String nome;
	private String cidade;
	private String estadio;
	
	public String getNomeTime() {
		return nome;
	}
	public void setNomeTime(String nomeTime) {
		this.nome = nomeTime;
	}
	public String getCidade() {
		return cidade;
	}
	public void setCidade(String cidade) {
		this.cidade = cidade;
	}
	public String getEstadio() {
		return estadio;
	}
	public void setEstadio(String estadio) {
		this.estadio = estadio;
	}
	@Override
	public String toString() {
		return "Time [nomeTime=" + nome + ", cidade=" + cidade + ", estadio=" + estadio
				+ "]";
	}
}
