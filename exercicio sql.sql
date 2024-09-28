-- 1. Liste o nome e a data de nascimento do empregado 'Joao Silva'. 
SELECT NomeFunc, DataNasc FROM funcionario WHERE NomeFunc = 'Joao Silva';

-- 2. Liste o nome e o endereço de todos os empregados que pertencem ao departamento 'Pesquisa'. 
SELECT F.NomeFunc, F.Endereco FROM funcionario AS F, departamento AS D WHERE F.ID_Depto = D.ID_Depto AND D.NomeDepto = 'Pesquisa';
SELECT F.NomeFunc, F.Endereco FROM funcionario AS F JOIN departamento D ON F.ID_Depto = D.ID_Depto WHERE D.NomeDepto = 'Pesquisa';

-- 3. Para cada projeto localizado no 'Luxemburgo', liste o numero do projeto, o número do departamento que o controla e o nome, endereço e data de aniversário do gerente do departamento. 
SELECT P.ID_Proj, D.ID_Depto, D.NomeDepto, G.NomeFunc, G.Endereco, G.DataNasc
FROM (projeto AS P JOIN departamento AS D ON P.ID_Depto = D.ID_Depto)
JOIN funcionario AS G ON D.ID_Gerente = G.ID_Func
WHERE P.Localizacao = 'Luxemburgo';

-- 4. Para cada empregado, recupere o seu nome e o nome de seu supervisor. 
SELECT F.NomeFunc, S.NomeFunc FROM funcionario AS F LEFT OUTER JOIN funcionario AS S ON F.ID_Superv = S.ID_Func;

-- 5. Selecione os empregados do departamento de número 1. 
SELECT * FROM funcionario AS F WHERE F.ID_Depto = 1;

-- 6. Liste o salário de todos os empregados, de tal forma que não apareçam salários iguais. 
SELECT DISTINCT Salario FROM funcionario;

-- 7. Liste todos os dados dos empregados que moram na 'Irai'. 
SELECT * FROM funcionario AS F WHERE F.Endereco LIKE '%Irai%';

-- 8. Liste o número de todos os projetos que possuem empregados com sobrenome 'Santos', como trabalhador ou como gerente do departamento que controla os projetos. 
SELECT ID_Proj FROM projeto
WHERE ID_Proj IN 
(SELECT T.ID_Proj FROM trabalha AS T NATURAL JOIN funcionario AS F WHERE F.NomeFunc LIKE '%Santos%')
OR ID_Proj IN 
(SELECT P.ID_Proj FROM (projeto AS P NATURAL JOIN departamento AS D) JOIN funcionario AS G ON G.ID_Func = D.ID_Gerente WHERE G.NomeFunc LIKE '%Santos%');

SELECT T.ID_Proj FROM trabalha AS T NATURAL JOIN funcionario AS F WHERE F.NomeFunc LIKE '%Santos%'
UNION
SELECT P.ID_Proj FROM (projeto AS P NATURAL JOIN departamento AS D) JOIN funcionario AS G ON G.ID_Func = D.ID_Gerente WHERE G.NomeFunc LIKE '%Santos%';

-- 9. Mostre o resultado do aumento de 20% sobre o salário dos empregados que trabalham no projeto de nome 'ProdX'. 
SELECT 1.2 * Salario FROM funcionario NATURAL JOIN trabalha NATURAL JOIN projeto WHERE NomeProj = 'ProdX';

-- 10. Liste o nome dos empregados do departamento 3 que possuem salário entre R$800,00 e R$1.200,00. 
SELECT NomeFunc FROM funcionario WHERE ID_Depto = 3 AND Salario BETWEEN 800 AND 1200;

-- 11. Liste o nome dos empregados, o nome dos seus departamentos e o nome dos projetos em que eles trabalham, ordenados pelo departamento e pelo nome do projeto. 
SELECT NomeFunc, NomeDepto, NomeProj
FROM funcionario AS F JOIN departamento AS D ON F.ID_Depto = D.ID_Depto
JOIN trabalha AS T ON F.ID_Func = T.ID_Func
JOIN projeto AS P ON T.ID_Proj = P.ID_Proj
ORDER BY NomeDepto, NomeProj;

-- 12. Liste o nome dos empregados que trabalham em algum dos projetos em que o 'Joao Silva' trabalha. 
SELECT DISTINCT NomeFunc FROM funcionario NATURAL JOIN trabalha AS T
WHERE T.ID_Proj IN (SELECT ID_Proj FROM funcionario AS F NATURAL JOIN trabalha WHERE NomeFunc = 'Joao Silva');

-- 13. Liste o nome dos empregados que não possuem supervisores. 
SELECT NomeFunc FROM funcionario AS F WHERE F.ID_Superv IS NULL;
SELECT NomeFunc FROM funcionario AS F WHERE NOT EXISTS (SELECT * FROM funcionario AS S WHERE F.ID_Superv = S.ID_Func);

-- 14. Liste o nome dos empregados que possuem mais que 2 dependentes, juntamente com os nomes dos seus dependentes.
SELECT NomeFunc, NomeDep FROM funcionario AS F JOIN dependente AS DEP ON F.ID_Func = DEP.ID_Func
WHERE (SELECT COUNT(*) FROM dependente AS D WHERE F.ID_Func = D.ID_Func) > 2;

-- 15. Liste a soma, a média, o maior e o menor salário de todos os empregados. 
SELECT SUM(Salario), AVG(Salario), MAX(Salario), MIN(Salario) FROM funcionario;

-- 16. Liste a soma, a média, o maior e o menor salário dos empregados do departamento 'Pesquisa'. 
SELECT SUM(Salario), AVG(Salario), MAX(Salario), MIN(Salario) FROM funcionario NATURAL JOIN departamento WHERE NomeDepto = 'Pesquisa';

-- 17. Liste o nome de cada supervisor com a quantidade de supervisionados. 
SELECT S.NomeFunc, COUNT(F.ID_Func) 
FROM funcionario AS F JOIN funcionario AS S
ON F.ID_Superv = S.ID_Func
GROUP BY S.NomeFunc;

-- 18. Liste o nome de cada projeto com o número de empregados que trabalham no projeto. 
SELECT P.NomeProj, COUNT(*)
FROM trabalha AS T NATURAL JOIN projeto AS P JOIN funcionario AS F
ON T.ID_Func = F.ID_Func
GROUP BY P.ID_Proj;

-- 19. Para cada projeto que possua mais de 2 empregados na equipe, liste o nome do projeto e a quantidade de empregados que trabalham no mesmo. 
SELECT P.NomeProj, COUNT(*)
FROM trabalha AS T NATURAL JOIN projeto AS P
GROUP BY P.ID_Proj
HAVING COUNT(*) > 2;

-- 20. Para cada departamento que possua mais do que 2 empregados, liste o nome do departamento e o nome dos empregados que ganham mais do que 800,00.
SELECT D.NomeDepto, F.NomeFunc
FROM departamento AS D JOIN funcionario AS F ON D.ID_Depto = F.ID_Depto
WHERE F.Salario > 800
AND D.ID_Depto IN (SELECT ID_Depto FROM funcionario GROUP BY ID_Depto HAVING COUNT(*) > 2); 