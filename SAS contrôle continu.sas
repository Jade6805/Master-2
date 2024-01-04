/*Jade - Contrôle continu */

/* Question 1 */
Data work.voiture;
Set SASHELP.CARS;
run; 

/* Question 2 - Ce code permet d'avoir toutes les données sur le data et sur les variables */ 
proc contents data=work.voiture;
run;

/* Question 3 - Le code est le même que pour la question 2 */ 
proc contents data=work.voiture;
run;

/* Question 4 */ 
proc sql;
create table work.origin_eng as 
select 
Origin as Origin
from work.voiture
quit;

/* Question 5 */ 
proc sql;
alter table work.origin_eng
add Origin_fr CHAR;
quit;

proc format;
Value usa
3 = "Etats-Unis" 
2 = "Origin" 
1 = "Origin" 
;
run; /* ne marche pas*/

proc format;
Value usa
"USA" = "Etats-Unis" 
Others = "Origin" 
;
run;/* ne marche pas*/

proc print data=work.origin_eng;
format Origin_fr usa.;
run;


/* Question 6 */ 
PROC SQL;
CREATE TABLE work.voiture_origin
AS
SELECT *
FROM work.voiture t1
left JOIN work.origin_eng t2 ON
(t1.Origin = t2.Origin);
QUIT;

/* Question 7 */ 
data work.voiture_usa work.voiture_asia_europe ;
set work.voiture ;
if Origin="USA" then OUTPUT work.voiture_usa ;
if Origin!="USA" then OUTPUT work.voiture_asia_europe ;
run ;

/* Question 8 */ 
data work.trie_prix;
set work.voiture; 
Keep Make Model Origin Invoice;
run; 

proc sort data=work.trie_prix ;
by Make descending Invoice;
run;

/* Question 9 - ne marche qu'en faisant un code après l'autre*/ 
data work.voiture_cher;
set work.trie_prix; 
run; 

Proc sort data=work.voiture_cher out= Invoicemax nodupkey;
by Make ;
Run; 

/* Question 10 */ 
data work.voiture;
set work.voiture;

ecart_moyenne_make = mean(Invoice)-Invoice;
Run;



/* Question 11 */ 
data work.voiture;
set work.voiture;
Initial =substr(Make,1,2);
Run; 

/* Question 12 */ 
data work.voiture_inital;
set work.voiture;
Run; 

proc sql
;
select
Make, 
Model,
Initial,
count(Initial) as nombre_observation
from work.voiture_inital
group by initial;
quit
;

/* Question 13 - groupe 0 à 3*/ 
Proc rank data=work.voiture
out=invoicemax groups=4 descending;
var Invoice ;
Ranks rang;
run;

/* Question 14 */ 
data work.quantile_invoice;
input Median Q1 Q3;
Run; 

PROC MEANS DATA=work.voiture Q1 Q3 mean;
VAR Invoice;
OUTPUT OUT=work.quantile_invoice
optnum=lvar;
run; /* ne marche pas */

PROC MEANS DATA=work.voiture Q1 Q3 mean;
VAR Invoice;
OUTPUT OUT=work.quantile_invoice;
run;

/*Question 15 */ 
PROC MEANS DATA=work.voiture Q1 Q3 mean;
VAR Invoice;
by Make;
OUTPUT OUT=work.quantile_invoice_make;
run;

PROC MEANS DATA=work.voiture Q1 Q3 mean;
VAR Invoice;
by Make;
OUTPUT OUT=work.quantile_invoice_make Q1 Q3 mean;
run; /* même soucis que précédemment, plusieurs solutions testées*/

/* Question 16 */ 
proc freq data=work.voiture;
table Origin*driveTrain /nocol norow nopercent nocum ;
run;

/* Question 17 */ 
proc freq data=work.voiture;
table Origin*driveTrain /nocol norow nopercent nocum ;
OUTPUT OUT=work.work_origin_drivetrain; 
run;

/* Question 18 */ 
proc freq data=work.voiture;
table Origin*driveTrain /nocol norow nocum nofreq;
run;

/* Question 19 */ 
proc sql;
select
count(Invoice) as nombre_invoice,
mean(Invoice) as moyenne_invoice,
max(Invoice) as max_invoice,
min(Invoice) as min_invoice
from work.voiture;
quit
;

/* Question 20 */
proc sql
;
create table work.voituyreweight as
select
driveTrain,
count(weight) as nombre_weight,
mean(weight) as moyenne_weight,
max(weight) as max_weight,
min(weight) as min_weight
from work.voiture
group by driveTrain
;
quit
;