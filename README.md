# Student-Mental-Health-Academic-Performance-Analysis

## 🎯 **Project Name:** **Student Well-being & Success Analytics**  

### 📝 **Brief Description:**  
This project analyzes the **relationship between mental health factors (depression, sleep, study habits) and academic performance** among students. Using **SAS programming**, it processes and merges datasets on **student depression levels** and **academic performance**, then performs **statistical tests and visualizations** to uncover key insights. The goal is to help educators and policymakers **identify risk factors** and **improve student outcomes**.  

---

## 🔑 **Key Features / What It Does:**  

### 📂 **Data Exploration & Cleaning**  
- Imports and examines **two datasets**:  
  - **Depression Data** (sleep, study hours, stress, depression status)  
  - **Performance Data** (exam scores, motivation, family background, etc.)  
- **Cleans missing values** and standardizes variables for analysis.  

### 🔄 **Data Manipulation & Merging**  
- **Converts study/sleep hours** into comparable formats.  
- **Merges datasets** for holistic analysis.  

### 📊 **Statistical & Visual Analysis**  
1. **Study Hours vs. Depression**  
   - Bar charts & **logistic regression** to assess correlation.  
2. **Sleep & Depression Impact on Exam Scores**  
   - **Chi-square tests, ANOVA, Tukey’s post-hoc tests**, and **interactive line graphs**.  
3. **Family Background Influence**  
   - **Linear/logistic regression** to link income, parental involvement, and depression with grades.  
4. **Motivation Analysis**  
   - **ANOVA and logistic models** to test its impact on grades and depression.  

---  

## 🛠 **Technologies Used:**  
- **SAS Programming** (Data steps, `PROC` procedures, statistical modeling).  
- **SAS Visual Analytics** (`SGPLOT` for graphs, `PROC FREQ`, `PROC MEANS`).  
- **Statistical Methods**:  
  - Logistic/Linear Regression  
  - Chi-square Tests  
  - ANOVA & Tukey’s HSD  
  - Odds Ratio Analysis  

---  

## 🚀 **Setup/Installation Instructions:**  

### **Prerequisites:**  
- **SAS Software** (SAS Studio, SAS Enterprise Guide, or SAS University Edition).  
- **Datasets**:  
  - `Depression Student Dataset.csv`  
  - `StudentPerformanceFactors.csv`  

### **Steps:**  
1. **Upload Datasets**  
   - Place files in a designated folder (e.g., `/home/u63877268/IST2034/Datasets/`).  

2. **Run the SAS Script**  
   - Open the script (`Final_Source_Code.sas`) in SAS.  
   - Update file paths in the `LIBNAME` and `INFILE` statements to match your directory.  
   - Execute the script step-by-step or all at once.  

3. **Review Output**  
   - **Logs**: Check for errors in data import/cleaning.  
   - **Results**: View tables, graphs, and statistical outputs in the SAS results viewer.  

### **Example Code Snippets:**  
```sas
* Sample: Merge datasets after standardization;
DATA ass.merged;
  MERGE ass.depreSort (rename=(SleepHrsDE = SleepHrs StudyHrsDE = StudyHrs))
        ass.perSort (rename=(SleepCat = SleepHrs StudyHrsPE_day = StudyHrs));
  BY Gender SleepHrs StudyHrs;
RUN;
```

