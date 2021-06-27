# SQL
Repozitář obsahuje 3 soubory:

- Script-7.sql - jednotlivé selecty
- Script-8.sql - jednotlivé selecty roztřízené dle tabulek
- Script-9.sql - vytvoření dočasných view a finální tabulky



Problémy a řešení:

- V průběhu projektu jsem narazila na několik problémů, z nichž některé jsem vyřešila, ale většina zůstala nevyřešených 

- Prvním a nejzásadnějším problémem byla vytíženost databázového serveru, zejména poslední týden před odevzdáním projektu. Nemám databázi na localhostu a v momentě, kdy byl již engeto databázový server vytížený, se mi už nepodařilo přetáhnout data k sobě na localhost. 
Tohle ovlivnilo především testování finálního kódu, protože query nikdy nedoběhla do konce ani při dotazech, které by za normálních okolností trvaly pouze pár milisekund. Z toho pak vyplývala i neochota řešit menší problémy, které nebyly vyloženě zásadní pro vytvoření finální tabulky.

- Dotaz pro roční období - nepodařilo se mi určit roční období přesně na den, resp. dotaz by nebyl stoprocentně funkční pro přestupný rok. Po přidání podmínky, zda je daný rok přestupný, dotaz skončil chybou. Roční období je tudíž nakonec určeno pouze dle daného měsíce.

- Spojování tabulek - Obrovský problém u mě nastal při zjištění, že ne každá tabulka má sloupce vedeny takovým způsobem, jakým bych potřebovala, aby se mi připojily záznamy k sobě. Např. u tabulky religions jsou záznamy vedeny jednou za 10 let, u tabulky economies jednou ročně, u tabulky countries není datum žádné a u tabulky covid-19_basic zase každý den. Snažila jsem se naplnit tabulku daty tak, aby v ní byly všechny státy a zároveň aby to nebyla tabulka plná nulových hodnot. Nicméně ke konci projektu jsem si všimla, že mi některé státy, jako jsou třeba Česká republika nebo Rusko, v průběhu spojování tabulek zmizely. Tady se vracím k prvnímu problému. Query mi běžela pro každý dotaz opravdu dlouho, proto jsem se těmihle "menšími" problémy již nezabývala a zůstaly neopravené

- Finální tabulka - dotaz, který by mi vrátil finální tabulku, se mi nepodařilo spustit. Query se samotným selectem běžela několik hodin, ale nedoběhla a při zrušení mi DBeaver zahlásil pouze "request timed out"