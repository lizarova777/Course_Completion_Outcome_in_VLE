# Predicting Course Completion Outcome in VLE

## Purpose

The purpose of this research is to determine whether students’ gender, age range, the average number of daily clicks, and the average assessment score can predict the course completion outcome. The secondary research question is whether the student’s age range has an effect on their average assessment score and whether the effect of student’s age range on their average assessment score is moderated by the student’s gender. 

## Methodology

In the present study, seven anonymized datasets were retrieved from the Open University in the United Kingdom (Kuzilek, Hlosta, & Zdrahal, 2017). The codebook can be found [here](https://analyse.kmi.open.ac.uk/open_dataset).They contain data regarding the students, courses, and student interaction with the Virtual Learning Environment (VLE) for seven courses, where students had access to the course materials online and their interactions with the materials were recorded. Three of these datasets were merged. 

### Participants

The dataset consists of 32,593 observations, which indicates that data has been gathered for 32,593 students. There are no missing values. However, the data of students, who have withdrawn from the courses, was omitted from the analysis. Thus, the data of only 22,437 students were used for the analyses after the omission of the withdrawn students. 

### Instruments

The variables of interest are the students’ gender, age range, the average number of daily clicks for each student, and the average assessment score for each student, which served as predictors. Gender is a dichotomous categorical variable with levels “Male” (coded as “0”) and “Female” (coded as “1”). The student’s age range is also a categorical variable with the following three levels: “17-35” (coded as “0”), “35-55” (coded as “1”), and “55 or greater” (coded as “2”). The student’s average number of daily clicks and average assessment score are continuous predictors, and the average assessment score is measured in percentage and ranges from 0 to 100. The outcome variable for the first research question is the course completion, which is operationalized as the student’s final result of the course. Students, who have withdrawn from the course, were omitted from the analysis, while students, who have finished the course with “distinction”, were considered as the passing students. Thus, the outcome variable, the student’s final result in the course presentation, is a dichotomous categorical variable with two following groups: “Pass” (coded as “1”) and “Fail” (coded as “0”). 

### Procedure

There were two following variables created: each student’s average number of daily clicks in the VLE and each student’s average assessment score in the seven courses. A binomial logistic regression was performed to answer the primary research question. A two-way ANOVA test for interaction was conducted to examine the secondary research question and followed up with simple main effects with Holm-Bonferroni correction, and the analysis of the main effect of the student’s age range. All of the analyses were evaluated at a 5% significant level. 

## Results

### Factors that Predict Course Completion Outcome

![Figure1](https://github.com/lizarova777/Course_Completion_Outcome_in_VLE/blob/master/Figure1.PNG)
![Figure2](https://github.com/lizarova777/Course_Completion_Outcome_in_VLE/blob/master/Figure2.PNG)

#### Model
```
glm1 <- glm(formula=final_result~age_band+gender+mean_click + mean_score+ age_band:gender, data=IVA2, family = "binomial" )
summary(glm1) # these are logit coefficients

## Interaction between age range and gender is not significant

## Coefficients:
coef(glm1) 

## Exponentiated (and rounded) coefficients
round(exp(coef(glm1)), 2) 
```
The results showed that the student’s gender, age range, the average number of daily clicks, and average assessment score are statistically significant in predicting the course completion outcome. Being student who is 55 years old or older had the most odds in passing the course. In particular, for every additional click made by a student, there is a 22% increase in the odds of a student passing the course. Similarly, for every additional increase in percentage in the student’s average assessment score, there is an 8% increase in passing the course. Being a student in a “35-55” age group increases the odds of passing a course by 14%. Likewise, being a student in a “55 or greater” age group increases the odds of passing a course by as much as 106%. Being a female student also increases the odds of passing a course by 22%. 

### Interaction of Age Range and Gender on the Average Assessment Score

![Figure6](https://github.com/lizarova777/Course_Completion_Outcome_in_VLE/blob/master/Figure6.PNG)
![Figure7](https://github.com/lizarova777/Course_Completion_Outcome_in_VLE/blob/master/Figure7.PNG)

#### Model
```
lm1 <- lm(mean_score ~ age_band*gender, 
          data = IVA2)
          
# Two-way interaction is significant, so must look at simple effects.

joint_tests(object = lm1, by = "age_band")

emm1 <- emmeans(object = lm1,
                specs = ~ gender| age_band,
                adjust = "none")
```

The results revealed that the student’s age range has an effect on their average assessment score, and that effect is moderated by the student’s gender. Specifically, the student’s gender has a differential effect on their average assessment score for those students who are 55 years old or older. Male students, who are 55 years old or older, scored on average higher on assessments than female students in the same age group. 

## References
Kuzilek J., Hlosta M., Zdrahal Z. (2017). Open University Learning Analytics dataset Sci. Data 4:170171 doi: 10.1038/sdata.2017.171.
