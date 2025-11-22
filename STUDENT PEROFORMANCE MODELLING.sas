/* 1 and 2 codes  */

proc import 
datafile="/home/u64297034/sasuser.v94/Students Performance Data A (2).xlsx"
out=work.students_data
dbms=xlsx
replace;
getnames=yes;
run;

proc freq data=work.students_data;
tables gender address famsize Pstatus Medu Fedu Mjob Fjob higher internet health Final_grade;
title "One-Way Frequency Tables for Categorical Variables";
run;

proc univariate data=work.students_data;
var age absences;
title "Summary Measures for Quantitative Variables";
run;

proc contents data=work.students_data;
run;

proc freq data= work.students_data;
tables gender*Final_grade / chisq;
tables address*Final_grade / chisq;
tables famsize*Final_grade / chisq;
tables Pstatus*Final_grade / chisq;
tables higher*Final_grade / chisq;
tables internet*Final_grade / chisq;
title "Two-Way Chi-Square Tests of Association with Final Grade";
run;

proc contents data=work.students_data;
run;
proc freq data=work.students_data;
table gender address famsize Pstatus higher internet Final_grade;
title "Variable with 2 Categories";
run;

/*3. LOGISTIC REGRESSION MODEL*/
proc logistic data=work.students_data plots=NONE;
class gender address famsize Pstatus higher internet /param=ref;
model Final_grade = gender address famsize Pstatus higher internet age absences /lackfit scale=PEARSON aggregate=(gender age address famsize Pstatus Medu Fedu Mjob Fjob higher internet health absences) ;
title"LOGISTIC REGRESSION MODEL"
run;

/*4. BEST FITTING MODEL*/

proc logistic data=work.students_data plots=all;
class gender address famsize Pstatus higher internet /param=ref;
model Final_grade = gender address higher internet absences /lackfit aggregate=(gender age address famsize Pstatus Medu Fedu Mjob Fjob higher internet health absences) scale=pearson INFLUENCE;
output out=pred_probs p=predicted_prob;
title"REDUCED LOGISTIC REGRESSION MODEL"
run;

/*5.INTERPRETING RESULTS*/
proc print data=pred_probs(obs=3);
   var Final_grade predicted_prob ;
   title" the first 3 observations with predicted probabilities";
run;
