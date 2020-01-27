# Anna Lizarov
# Factors that Predict the Course Completion Outcome
# HUDM 5123 Data Analysis Project

# Libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(car)
library(EffectStars)
library(nnet)
library(emmeans)

# Dataset
load("IVA.Rdata")
IVA=IVA

############### 
# Primary Research Question
############### 

## Omitting students who have withdrawn
IVA2 = IVA
IVA2 <- filter(IVA2, final_result != "Withdrawn")  #remove students who withdrew
IVA2$final_result[IVA2$final_result == "Distinction"] <- "Pass"  #rows where final_result = distinction where renames to "pass" 
IVA2$final_result = factor(IVA2$final_result)
table(IVA2$final_result)
## Bar graph
ggplot(IVA2, aes(final_result)) + geom_bar(fill = "red") + labs(title = "The Number of Students Passing or Failing the Course", x = "Student's Final Result", y = "Frequency") + theme_classic()

## Recoding
### Student's gender
IVA2$gender = ifelse(IVA2$gender == "M", 0, 1)
IVA2$gender= factor(IVA2$gender, levels = c(0,1), labels= c("M", "F"))
### Student's final result (course completion outcome)
IVA2$final_result = ifelse(IVA2$final_result == "Fail", 0, 1)
IVA2$final_result= factor(IVA2$final_result, levels = c(0,1), labels= c("Fail", "Pass"))
### Student's age range
IVA2$age_band = ifelse(IVA2$age_band == "0-35",0, ifelse(IVA2$age_band == "35-55", 1, 2))
IVA2$age_band= factor(IVA2$age_band, levels = c(0,1,2), labels= c("17-35", "35-55", "55<="))

## Boxplots for Diagnostics
boxplot(IVA2$mean_click ~ IVA2$final_result,
        horizontal = TRUE,
        main = "Boxplot of Average Number of Daily Clicks \nby Final Course Result",
        xlab = "Average Number of Daily Clicks",
        ylab = "Final Course Result")

# Dummy-Coding of the categorical variables

options(contrasts = c("contr.treatment", "contr.poly"))
levels(IVA2$final_result) # will set "Fail" as a reference category

# Logistic Regression Model

glm1 <- glm(formula=final_result~age_band+gender+mean_click + mean_score+ age_band:gender, data=IVA2, family = "binomial" )
summary(glm1) # these are logit coefficients

## Interaction between age range and gender is not significant

## Coefficients:
coef(glm1) 

## Exponentiated (and rounded) coefficients
round(exp(coef(glm1)), 2) 

############### 
# Secondary Research Question
###############

## Omitting students who have withdrawn
IVA2 = IVA
IVA2 <- filter(IVA2, final_result != "Withdrawn")  #remove students who withdrew
IVA2$final_result[IVA2$final_result == "Distinction"] <- "Pass"  #rows where final_result = distinction where renames to "pass" 
IVA2$final_result = factor(IVA2$final_result)
table(IVA2$final_result)

## Recoding

### Student's gender
IVA2$gender = ifelse(IVA2$gender == "M", 0, 1)
IVA2$gender= factor(IVA2$gender, levels = c(0,1), labels= c("M", "F"))
### Student's final result (course completion outcome)
IVA2$final_result = ifelse(IVA2$final_result == "Fail", 0, 1)
IVA2$final_result= factor(IVA2$final_result, levels = c(0,1), labels= c("Fail", "Pass"))
### Student's age range
IVA2$age_band = ifelse(IVA2$age_band == "0-35",0, ifelse(IVA2$age_band == "35-55", 1, 2))
IVA2$age_band= factor(IVA2$age_band, levels = c(0,1,2), labels= c("17-35", "35-55", "55<="))

# Deviation Coding

options(contrasts = c("contr.sum", "contr.poly")) 

# Models

## Fit the full model.
lm1 <- lm(mean_score ~ age_band*gender, 
          data = IVA2)
summary(lm1)
lm1R <- lm(mean_score ~ age_band + gender, data= IVA2)
summary(lm1R) # look at reduced model
anova(lm1R,lm1) # incremental F test to see interaction term
Anova(lm1, type = "III")

# Assumptions
## Normality Assumption

qqPlot(lm1)

## Distribution of the outcome variable, average assessment score

hist(IVA$mean_score, main = "Histogram of the Students' Average Assessment Scores", xlab="Student's Average Assessment Score")

## Evaluating Heteroskedasticity

residualPlot(lm1, type = "rstudent")

#Interaction Plot

emmip(object = lm1, 
      formula = gender ~ age_band, # trace factor first, x factor second
      xlab = "Age Range",
      ylab = "Estimated Marginal Means")

# Two-way interaction is significant, so must look at simple effects.

joint_tests(object = lm1, by = "age_band")

emm1 <- emmeans(object = lm1,
                specs = ~ gender| age_band,
                adjust = "none")
plot(emm1, 
     horizontal = FALSE,
     ylab = "Average Asssessment Score", 
     xlab = "Age Range")

# Pairwise Comparisons

pairs(emm1, adjust = "holm")
summary(emm1, adjust = "holm") # Holm-Bonferroni Correction

## Plot of simple pairwise comparisons 

plot(emm1,
     horizontal = FALSE,
     ylab = "Average Assessment Score", 
     xlab = "Gender",
     adjust = "holm",
     int.adjust = "holm",
     comparisons = TRUE)

# Main effect of the student's age
## ANOVA Type III Approach
Anova(lm1, type = "III")
