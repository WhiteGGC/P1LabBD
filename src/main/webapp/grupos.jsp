<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./css/styles.css">
<meta charset="ISO-8859-1">
<title>Gerar Grupos</title>
</head>
<body>
	<div align="center">
		<nav id=menu>
			<ul>
				<li><a href="index.jsp">In?cio</a></li>
				<li><a href="grupos.jsp">Gerar Grupos</a><li>
				<li><a href="jogos.jsp">Gerar Jogos</a></li>
				<li><a href="tabela.jsp">Tabela de Grupos</a></li>
				<li><a href="datas.jsp">Datas</a></li>
			</ul>
		</nav>
	</div>
	<br />
	<br />
	<div id= "centro" align="center">
		<h1 class=texto>Campeonato Paulista</h1>
		<h3 class=tarefa>Gerador de grupos</h3>
		<div align="center">
			<form action="grupo" method="post">
				<input type="submit" id=gerar_grupo name=gerar_grupo
					value="Gerar Grupos">
			</form>
		</div>
		<div align="center">
			<c:if test="${not empty erro}">
				<h4>
					<c:out value="${erro}"></c:out>
				</h4>
			</c:if>
		</div>
		<br />
		<div align="center">
			<c:if test="${not empty grupos }">
				<table class=table_home>
					<thead>
						<tr>
							<th>Grupos</th>
							<th>Nome</th>
							<th>Cidade</th>
							<th>Estadio</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${grupos}" var="g">
							<tr>
								<td align="center"><c:out value="${g.grupo }"></c:out></td>
								<td align="center"><c:out value="${g.time.nomeTime }??"></c:out></td>
								<td align="center"><c:out value="${g.time.cidade }??"></c:out></td>
								<td align="center"><c:out value="${g.time.estadio }??"></c:out></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>
		</div>
		<div align="center">
			<c:if test="${not empty saida}">
				<h4>
					<c:out value="${saida}"></c:out>
				</h4>
			</c:if>
		</div>
	</div>

</body>
</html>