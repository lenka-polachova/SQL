# SQL
Repozitář obsahuje 3 soubory:

- Selects.sql - jednotlivé selecty
- Views.sql - jednotlivé selecty roztřízené dle tabulek
- Final_script.sql - vytvoření dočasných view a finální tabulky



Problémy a řešení:

- V tabulce covid19_basic je Česká republika vedena jako 'Czechia'
	=> vytvořila jsem sloupec country_replaced, kde je ČR vedena jako 'Czech Republic'

- Některé tabulky nemají datum vedeno v takovém formátu, aby se daly bez probému napojovat na sebe

- V soboru Final_Script prozatím nefunguje celý select, ze kterého budu následně tvořit tabulku
	=> chybí připojení sloupců z tabulky economies => způsobem, jakým je script napsán, nedoběhne nikdy do konce