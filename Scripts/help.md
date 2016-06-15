---
title: "Help"
author: "Rajesh Korde"
date: "June 15, 2016"
output: html_document
---

##Impact Analysis

Impact Analysis uses the CasualImpact package to estimate the effect of an intervention on the outcome variable. Technical details about the package can be found here.

The pre-experiment period refers to the period before the intervention. The Experiment period refers to  the period during which the intervention is occurring. The csv file contains data for the outcome variable for the both pre-experiment and experiment periods. The file should not have any header and should be the following format:
<Date>, <Control Data>, <Experiment Data>

###Example:
 A sample experiment csv file is uploaded here. The pre.experiment duration for this file is 5/10/2016 to 5/23/2016 and Experiment duration for this file is 5/24/2016 to 6/4/2016. The sample experiment file should show a lift of 0% with the confidence interval of -14% to +14%.

##Test of Means
Test of means conducts the difference of means test under the null hypothesis that there is no difference between the means between the groups. This is used for cases when the response variable has a continuous value as an outcome eg number of searches, engagement time etc. For example, each experimental unit having a engagement time duration after receiving an impression.

**Null Hypothesis:** There is no difference in the means of outcome variable between the control and treatment group.

**Lift:** (treatment mean - control mean) / control mean

**Significance.level (aka p-value):** probability of finding the observed results when the null hypothesis is true. At the very least, the p-value should be less than 0.05.

**t-test:** parametric test that compares the means of two groups of values. Susceptible to outliers.

**Wilcoxon rank sum test:** non-parametric test that compares the ranks of two groups of values. Not susceptible to outliers.

*Power:** probability of the test rejecting a false null hypothesis (As in the likelihood that the test will detect an effect where there is indeed an effect to be detected). Ideally, the power of the test should be greater than 0.8.

**Ideal Sample Size:** What would have been the ideal sample size for this test of means, that would detect the current difference in means, given the current standard deviation of control group, 0.8 power, 0.05 significance level and a 50-50 split between control and treatment group.

The csv file contains data for control and treatment groups. It should not have any header and should be in the following format:
<ID>, <Group>, <Value>
Here, ID refers to ID of the experimental unit, Group refers to "Control" or "Treatment" and Value refers to value of the response variable.

###Example:
A sample test mean of means file is uploaded here. Uploading this file should show a lift of 3.87% with a p-value of 0.00781 for t-test and 0.00646 for Wilcoxon rank sum test.

##Test of Proportions
Test of proportions conducts the difference of proportions test under the null hypothesis that there is no difference between the means between the groups. This is used for cases when the response variable has a binary outcome eg CTR, optout etc. For example, each experimental unit having a binary outcome of either clicking or not clicking through on an impression. This gives us a proportion of users in control and treatment groups who clicked through on getting an impression.

**Null Hypothesis:** There is no difference in the proportions of outcome variable between the control and treatment group.

**Lift:** (treatment proportion - control proportion) / control proportion

**Significance.level (aka p-value):** probability of finding the observed results when the null hypothesis is true. At the very least, the p-value should be less than 0.05.

**t-test:** parametric test that compares the means of two groups of values.

**Power:** probability of the test rejecting a false null hypothesis (As in the likelihood that the test will detect an effect where there is indeed an effect to be detected). Ideally, the power of the test should be greater than 0.8.

**Ideal Sample Size:** What would have been the ideal sample size for this test of proportion, that would detect the current difference in proportions, given the current control group sample size, 0.8 power, 0.05 significance level and a 50-50 split between control and treatment group.

The csv file contains data for control and treatment groups. It should not have any header and should be in the following format:
<ID>, <Group>, <Value>
Here, ID refers to ID of the experimental unit, Group refers to "Control" or "Treatment" and Value refers to value of the response variable.

###Example:
The following table shows the result of an experiment:

   Group  |Proportion|Sample Size
 ---------|----------|-----------
Control   |  185     |  23888
Treatment |  307     |  32762

Entering this data would show you a lift of 21% and a p-value of 0.044.