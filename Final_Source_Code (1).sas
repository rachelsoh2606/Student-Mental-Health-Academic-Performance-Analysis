*2.1: DATA EXPLORATION;

*2.1.1: Create LIBNAME to link the assignment folder in SAS library;
LIBNAME ass "/home/u63877268/IST2034/Datasets";

*2.1.2: Read Depression dataset;
DATA ass.oriDepre;
	INFILE "/home/u63877268/IST2034/Datasets/Depression Student Dataset.csv" DSD TRUNCOVER FIRSTOBS = 2;
	LENGTH SleepHrsDE $ 19. Dietary $ 9.;
	INPUT Gender $
			Age 
			AcaPressure
			StudySatis
			SleepHrsDE $ 
			Dietary $
			Suicidal $
			StudyHrsDE
			FinStress
			FamHis $
			Depression $
			;
RUN;

*2.1.3: Read Performance dataset;
DATA ass.oriPer;
	INFILE "/home/u63877268/IST2034/Datasets/StudentPerformanceFactors.csv" DSD TRUNCOVER FIRSTOBS = 2;
	LENGTH ParentEdu $ 12.;
	INPUT StudyHrsPE
			Attendance
			ParentalInvolvement $
			AccessResources $
			Extracurricular $
			SleepHrsPE
			PrevScore
			Motivation $
			Internet $
			Tutoring
			FamIncome $
			TeachQuality $
			SchoolType $
			Peer $
			ActivityHrs 
			LearnDisabilities $
			ParentEdu $
			Distance $
			Gender $
			ExamScore
			;
RUN;

*2.1.4: Check descriptor portion;			
PROC CONTENTS DATA = ass.oriDepre VARNUM;
RUN;

PROC CONTENTS DATA = ass.oriPer VARNUM;
RUN;

*2.1.5: View number of observations, min, max & check for missing values;
*2.1.5.1: For Depression Dataset's numeric variable;
TITLE "Depression Dataset Summary for Numeric Variable";
PROC MEANS DATA = ass.oriDepre N NMISS MIN MAX MAXDEC = 1;
RUN;
TITLE;

*2.1.5.2: For Depression Dataset's character variable;
TITLE "Depression Dataset Summary for Character Variable";
PROC FREQ DATA = ass.oriDepre;
	TABLES _character_ / NOCUM NOPERCENT;
RUN;
TITLE;

*2.1.5.3: For Performance Dataset's numeric variable;
TITLE "Performance Dataset Summary for Numeric Variable";
PROC MEANS DATA = ass.oriPer N NMISS MIN MAX MAXDEC = 1;
RUN;
TITLE;

*2.1.5.4: For Performance Dataset's character variable;
TITLE "Performance Dataset Summary for Character Variable";
PROC FREQ DATA = ass.oriPer;
	TABLES _character_ / NOCUM NOPERCENT;
RUN;
TITLE;

/*Data Exploration Contributed by: Rachel Soh En Qi*/

*2.2: DATA CLEANING;
*2.2.1: Delete observations in Performance Dataset that have missing value;
DATA ass.cleanPer;
	SET ass.oriPer;
	IF cmiss(of _all_) = 0 ;
RUN;

*2.2.2: Check missing value for Performance Dataset;
TITLE "Performance Dataset Summary for Character Variables after Data Cleaning";
PROC FREQ DATA = ass.cleanPer;
	TABLES _character_ / NOCUM NOPERCENT;
RUN;
TITLE;

*2.2.3: Check total number of observations in Performance datasets;
TITLE "Performance Dataset Descriptor Portion after Data Cleaning";
PROC CONTENTS DATA = ass.cleanPer VARNUM;
RUN;
TITLE;


*2.3: DATA MANIPULATION;
*2.3.1: Standardize variables;
DATA ass.maniPer;
	SET ass.cleanPer;
	LENGTH SleepCat $ 19.;

	/*
	Performance Dataset's study hours is per week, 
	divide by 7 to standardize with Depression Dataset
	*/
	
	StudyHrsPE_day = ROUND(StudyHrsPE / 7, 1);
	DROP StudyHrsPE;
	
	/*
	Performance Dataset's sleep hours is in numeric,
	convert to category to standardize with Depression Dataset
	*/
	
	IF SleepHrsPE < 5 THEN
		SleepCat = "Less than 5 hours";
	ELSE IF SleepHrsPE >=5 AND SleepHrsPE <= 6 THEN
		SleepCat = "5-6 hours";
	ELSE IF SleepHrsPE >=7 AND SleepHrsPE <= 8 THEN
		SleepCat = "7-8 hours";
	ELSE IF SleepHrsPE > 8 THEN
		SleepCat = "More than 8 hours";
	
	DROP SleepHrsPE;
	
RUN;

*2.3.2: Sorting Depression dataset by Gender, SleepHrsDE StudyHrsDE;
PROC SORT DATA=ass.oriDepre OUT=ass.depreSort;
	BY Gender SleepHrsDE StudyHrsDE;
RUN;

*2.3.3: Sorting Performance dataset by Gender, SleepCat StudyHrsPE_day;
PROC SORT DATA=ass.maniPer OUT=ass.perSort;
	BY Gender SleepCat StudyHrsPE_day;
RUN;

*2.3.4: Merging both datasets into one dataset by standardizing variable names;
DATA ass.merged;
	MERGE ass.depreSort	(rename=(SleepHrsDE = SleepHrs 
									StudyHrsDE = StudyHrs))
			ass.perSort (rename=(SleepCat = SleepHrs 
									StudyHrsPE_day = StudyHrs));
	BY Gender SleepHrs StudyHrs;
RUN;

*2.3.5: Check for missing values in merged dataset;
*2.3.5.1.: For numeric variable;
TITLE "Merged Dataset Summary Numeric Variable";
PROC MEANS DATA = ass.merged N NMISS;
RUN;
TITLE;

*2.3.5.2: For character variable;
TITLE "Merged Dataset Summary Character Variable";
PROC FREQ DATA = ass.merged;
	TABLES _character_ / NOCUM NOPERCENT;
RUN;
TITLE;

*2.3.6: Delete observations that have missing values;
DATA ass.finalmerged;
	SET ass.merged;
	IF cmiss(of _all_) = 0 ;
RUN;

/*Data Cleaning, Manipulation Contributed by: Ng Li Qin*/

/*3.1: Research Question 1: 
What is the relationship between study hours and depression level?*/

/*3.1.1: Compute the individual bar chart for the StudyHours*/
title "Study Hours Distribution by Percentage";
proc sgplot data=ass.finalmerged;
    vbar StudyHrs / response=StudyHrs stat=percent datalabel;
    xaxis label="Study Hours";
    yaxis label="Percentage" grid;
run;
title;

/*3.1.2: Compute the individual bar chart for Depression*/
title "Depression Status Distribution by Percentage";
proc sgplot data=ass.finalmerged;
    vbar Depression / response=StudyHrs stat=percent datalabel;
    xaxis label="Depression Status";
    yaxis label="Percentage" grid;
run;
title;

/*3.1.3: Compute a combined bar chart for the StudyHrs and Depression*/
title "Relationship Between Study Hours and Depression Levels";
proc sgplot data=ass.finalmerged;
    vbar StudyHrs / group=Depression response=StudyHrs stat=percent 
        groupdisplay=cluster;
    xaxis label="Study Hours";
    yaxis label="Percentage";
run;
title;

/*
3.1.1 & 3.1.2 bar chart
3.1.3 Combined bar chart
contributed by Mok Qi Yeng
*/

/*3.1.4: Logistic Regression to determine the relationship between StudyHrs and Depression*/
proc logistic data=ass.finalmerged;
    /*Specify Study_Hours as categorical */
    class StudyHrs (ref='1') / param=ref; 
    /*Response = Predictor */
    model Depression(event='Yes') = StudyHrs; 
    /*Specify to find the odds ratios for every level to come out with a valid conclusion*/
    oddsratio StudyHrs / diff=all; 
run;

/*
3.1.4 logistic regression
contributed by Rachel Soh En Qi
*/


/*3.2: Research Question 2: 
How do sleep hours and depression level impact exam score?*/

/*3.2.1: Analyze the data of two categorical variables using chi-square test*/
title "Distribution of SleepHrs and Depression level";
proc freq data = ass.finalmerged;
	tables sleephrs*depression / chisq;
run;
title;

/*3.2.2: Look for relationship of sleep hours and exam score using line graph*/
proc means data=ass.finalmerged noprint;
    class SleepHrs;
    var ExamScore;
    output out=avgSleep mean=MeanExamScore;
run;

title "Sleep Hours vs Exam Score Line Graph";
proc sgplot data=avgSleep;
	series x=SleepHrs y= MeanExamScore / markers;
	xaxis label="Sleep Hours";
    yaxis label="Average Exam Score" ;
run;
title;

/*3.2.3: Look for relationship of depression and exam score using line graph*/
proc means data=ass.finalmerged noprint;
    class Depression;
    var ExamScore;
    output out=avgDepression mean=MeanExamScore;
run;

title "Depression vs Exam Score Line Graph";
proc sgplot data=avgDepression;
	series x=Depression y= MeanExamScore / markers;
	xaxis label="Depression";
    yaxis label="Percentage";
run;
title;

/*3.2.4: Look for two-way anova relationship*/
title "Two-way anova: Impact of Sleep Hours and Depression on Exam Scores";
proc glm data=ass.finalmerged plots(maxpoints=7000);
	class SleepHrs Depression;
    model ExamScore = SleepHrs Depression SleepHrs*Depression / ss3;
    means SleepHrs Depression;
run;
title;

/*
3.2.1. chi-square test
3.2.2. & 3.2.3. line graph
3.2.4. two-way anova relationship
contributed by Mok Qi Yeng
*/

/*3.2.5: Post-Hoc Analysis to determine 
Sleep Hours & Exam Score's direction of relationship*/
title "Post-Hoc Analysis: Tukey's Test for Sleep Hours";
proc glm data=ass.finalmerged plots(maxpoints=7000);
   class SleepHrs;
   model ExamScore = SleepHrs;
   means SleepHrs / tukey alpha=0.05;
run;
title;

/*3.2.6: Post-Hoc Analysis to determine 
Interaction Effect of Sleep Hours and Depression Level 
& Exam Score's direction of relationship*/
title "Post-Hoc Analysis: Tukey's Test for Interaction 
	Effect of Sleep Hours and Depression Level";
proc glm data=ass.finalmerged plots(maxpoints=7000);
   class SleepHrs Depression;
   model ExamScore = SleepHrs*Depression;
   means SleepHrs*Depression / tukey alpha=0.05;
run;
title;

/*3.2.7: To visualise the relationship*/
/*Calculate the mean ExamScore for each combination 
of SleepHrs and Depression level */
proc means data=ass.finalmerged noprint;
    class SleepHrs Depression;
    var ExamScore;
    output out=combined_means mean=mean_exam_score;
run;
/*Plot Line Graph*/
title "Sleep Hours vs Mean Exam Score by Depression Level";
proc sgplot data=combined_means;
    series x=SleepHrs y=mean_exam_score / group=Depression 
        lineattrs=(thickness=2) 
        legendlabel="Depression Level";
    xaxis label="Sleep Hours";
    yaxis label="Mean Exam Score";
run;
title;

/*
3.2.5. & 3.2.6. Post-Hoc Analysis
3.2.7. Visualising relationship 
contributed by Ng Li Qin
*/

/*3.3: Research Question 3: 
Does family background (Family Income, Family History of Depression, Parental Involvement) correlate with depression levels or academic success?*/

*3.3.1: Look for relationship between exam score 
and family background using linear regression;
/* Check frequencies of family related variables*/
proc freq data=ass.finalmerged;
   tables FamIncome FamHis ParentalInvolvement / missing;
run;

/* Perform linear regression to examine family background 
factors affecting exam scores */
title "Linear Regression: Exam Score and Family Background";
proc glm data=ass.finalmerged;
   class FamIncome FamHis ParentalInvolvement;
   model ExamScore = FamIncome FamHis ParentalInvolvement;
   means FamIncome FamHis ParentalInvolvement / hovtest=levene;
run;

title;

/*
3.3.1 linear regression
contributed by Wong Shi Wen
*/

*3.3.2: Examine the relationship between depression 
and family background using logistic regression;
/* Check frequencies of family related variables*/
proc freq data=ass.finalmerged;
   tables FamIncome FamHis ParentalInvolvement Depression / missing;
run;

/* Perform logistic regression and produce odds ratio graph to examine family background 
factors affecting depression */
title "Logistic Regression: Depression and Family Background";
proc logistic data=ass.finalmerged;
   class FamIncome(ref='Low') FamHis(ref='No') 
         ParentalInvolvement(ref='Low') / param=ref;
   model Depression(event='Yes') = FamIncome FamHis ParentalInvolvement;
   oddsratio FamIncome;
   oddsratio FamHis;
   oddsratio ParentalInvolvement;
run;

title;

/*
3.3.2 logistic regression
contributed by Christina Lim Yu Yee
*/

/*3.4: Research Question 2: 
Are students with high motivation less likely to experience depression and more likely to achieve higher exam scores? */

*3.4.1: Look for relationship between 
motivation level and exam score using line graph;
/* Calculate average exam score for each motivation level */
proc means data=ass.finalmerged noprint;
    class motivation;
    var ExamScore;
    output out=ExamScoreSummary mean=MeanExamScore;
run;

/* Plot line graph of motivation level vs average exam score */
title "Motivation Level vs Exam Score Line Graph";
proc sgplot data=ExamScoreSummary;
    series x=motivation y=MeanExamScore / 
        markers 
        datalabel=MeanExamScore 
        lineattrs=(color=blue thickness=2 pattern=solid)
        markerattrs=(symbol=circlefilled size=9 color=blue);
    xaxis label="Motivation Level" discreteorder=data 
        labelattrs=(size=12 weight=bold) 
        valueattrs=(size=10);
    yaxis label="Average Exam Score" 
        labelattrs=(size=12 weight=bold) 
        valueattrs=(size=10) grid;
    keylegend / position=topright across=1 location=inside;
run;
title;

/*
3.4.1 Line Graph
contributed by Wong Shi Wen
*/

/*3.4.2 ANOVA for Motivation vs Exam Score */
title 'ANOVA: Motivation vs Exam Score';
proc anova data=ass.finalmerged;
   class Motivation;
   model ExamScore = Motivation; 
   means Motivation;
run;
title;

/*3.4.3 Logistic regression for Motivation vs Depression */
title "Logistic Regression: Motivation and Depression";
proc logistic data=ass.finalmerged;
   class Motivation(ref='Low') / param=ref; 
   model Depression(event='Yes') = Motivation; 
   oddsratio Motivation; 
run;
title;

/*
3.4.2 Anova Test
3.4.3 Logistic Regression
contributed by Oon Jing Xuan
*/

/*
Source Code compiled by Christina Lim Yu Yee
*/
