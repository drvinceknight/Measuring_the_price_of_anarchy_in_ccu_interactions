# Reviewers' comments:

> AE: We received comprehensive reports from two reviewers. Both reviewers have serious concerns on the paper and I agree with them. The main concerns are summarized below.
>
> Validity of the model and assumptions:
> - Similar research already has been done in the literature and the authors miss relevant references (reviewer 2).
> - It seems unreasonable that hospitals often transfer critical care patients in practice (reviewer 2).
> - The game theoretical model should be known by both hospitals in order to work (reviewer 1). Moreover, each hospital should know the parameters of the other. It is questionable whether this is a realistic assumption.
> - It is unclear why the hospitals have a "bed utilization target" of t=0.8. Where does it come from? Furthermore, it contradicts other objectives of the hospitals like maximizing throughput (reviewers 1 and 2).
> - The assumption on the services time after diversion of patients is questionable (reviewer 2).
>
> Mathematics:
> - The theorem and lemma seem to hold but the proofs are not convincing (reviewer 1). The proofs should be done in a more rigorous and formal way.
>
> Computational results:
> - The price of anarchy (w.r.t. throughput) is used to compare different models, but it is unclear whether this is the right way to measure the lack of coordination.
> - The results consist of two numerical examples. It is unclear how much the results generalize.
>
> After combining the two reports, there are too many (major) issues that need to be resolved and hence I recommend rejection.
>
>
> Reviewer #1: Overall - the model is appealing, and using a combination of Markov chains in a game theoretic  setting is interesting. The results are consistent with common sense, which has the advantage of increasing credibility, but it also reduces the contribution of the paper.
>
> Minor comments:
>
> Abstract - "A theoretical result is given that ensures the existence of a Nash Equilibrium". If it is a condition that ensures NE, please say so. If it is a theorem that proves a NE exists for all these games, then use the word theorem, as it is more precise. The sentence as it stands is ambiguous.

Have re worded this (#3fd71a0).

>
> Editorial comments - the paper needs to be tightened up. The intro repeats itself (e.g. "shortage of beds" in paragraph one, then "beds are very expensive and a limited resource" in paragraph two).  However, a single good effort in cleaning up the prose should suffice. Some of the paragraphs are so high-level they can safely be excised; e.g. the 5th paragraph of the introduction on game theory.

Re read and fix all this.*

>
> It is not necessary to use the word "selfish" to describe hospitals behavior, as "rational" is a more precise descriptor that does not carry as much negative baggage (p3line6). Further, if the goal is "throughput", as listed on p5line21, then one could make the argument that the hospital is merely striving to serve the greatest number of patients.

Have changed selfish to rational (#76a905f).

>
> Figure one looks as if patients enter, but never leave; exit arrows would be an improvement. Also, the oddly shaped lines are distracting (there is no reason to insist on the boxes on the same horizontal line).

Have added exit arrow to diagram (#b07c476).

>
> Figure 3 seems to suggest that the service rate is constant no matter how many patients are present. But elsewhere (p5lines6&7) the service rates are proportional to the stock of patients. This can be fixed by changing the scripts on the appropriate arrows in Figure 3.

Have addressed this in all the arrows (#d3f772b).

>
> Equation 2, the definition of qij on page 5 lines 6-18, could be improved with a bit more explanation.

This has been slightly changed (#f8d4cc6).

>
> P14line51 has the word "environmenta", and the sentence seems to be missing some portion.

Have fixed this error (#03b6056).

>
> Acronyms and notation - Table 1 is useful, but a similar overview for acronyms would be equally helpful. One question about Table 1: the numbers do not appear to be state-dependent, even though that is stated in the text. They may be derived from the data, but they may also be simple averages, in which case the arrival rates are not conditioned on the other hospital not being on diversion. A brief explanation would be welcome.

Explain where this come from.*

>
> The use of a, b, c, and d in Figure 2 is not intuitive; using e.g. (l,l) or (h,h) for "low and low" or "high and high" utilizations would be much more clear.

This has been changed throughout (#a237de7).

>
> Substantive comments:
>
> The claim on page 2 lines 31 and 32 doesn't seem to be supported by subsequent work. First, which "targets", unless it is the elusive "t" from page 6? Second, the existence of a NE doesn't mean the equilibrium is socially optimal.

Not actually sure what is meant here.*

>
> It is not clear the states can be indexed lexicographically, as suggested on page 3 line 43. Yes, they can be listed such that a larger population of patients is greater than a smaller one, but each "state" with a given number of patients can have many different values for the number of patients in each hospital. This is reflected in the conditions for equation 2, but since these are clearly necessary, what is gained by suggesting the system goes from i to j? I would argue the model would be more clear if (i,j),(k,l) were used to index the states.

I agree and have removed the s, although the rest of the comment doesn't make sense (this ordering is standard). (#063fa75)

>
> If the hospitals minimize the problem on page 6, then they are simply aiming for the "bed utilization target" of 0.8, explicitly not trying to maximize throughput. This seems to be a direct internal contradiction. Second, the value for "t" is claimed to come from the data , although this does not seem possible; how was the value for t selected?

Describe where $t$ comes from better.*

>
> For the theorem on page 7, the best response function is such that the squared difference between utilization rate and target bed utilization rate is minimized. But in order for this to work, the entire model must be known and estimated by each hospital. Further, the best response function is based on the diversion threshold for the other, which is not explicitly assumed to be known. However, even if these assumptions are stipulated, there seems to be a gap in the proof (or perhaps it just needs to be explained more clearly): "in case of the multiple values that minimize Uh, it is assumed that fh returns the lowest such value". If so, how is that consistent with maximizing the number of served patients? Further, the original NE paper dealt with the situation where only a mixed equilibrium guaranteed that any NE existed. In this scenario, we could have a situation where 50% probability of using e.g. 10 beds and 11 beds for each hospital is a Nash equilibrium. But if we insist
> that one uses 10, then the other may well use 11, rather than the 10 that is indicated in the proof. Further, because the functions have a discrete range, it is not "obvious" that the functions must intersect, nor is there any "point of intersection" illustrated in Figure 7.

Have added a better justification as to why the worst case is used. (#fbec792)

>
> Moving on to the Lemma, p8l6 seems to be stating that for the reasonable assumption of arrival rates (going up if the other hospital diverts), then if we fix the threshold for NH, an increase in the threshold for RG will lead to the arrival rate to NH to at the least not increase. I.e. as RG takes more patients, no more patients arrive at NH, which is reasonable. But the next sentence states the reverse for RG, i.e. that if RG has a fixed threshold, then increasing the threshold to NH makes the arrival rate to RG at the very least not go down. This second statement does not seem reasonable.
>
> P8lines 10-12 are very reasonable, as they seem to be saying that if the other hospital increases its threshold, the utilization rate of the first cannot increase. And the second statement is that if the first hospital increases its threshold, it cannot have a decrease in utilization rate. However, the statements do not appear to rely on the previous observation, although that is claimed. It is not clear how the verbal statements imply the next; a more formal approach would be welcome.

Write down more formal approach for these theorems (transform what I have said verbally to mathematical statements).*

>
> Finally (for the lemma), there is a "graphical proof" supplied in Figure 8, which is not convincing. It does seem reasonable that the shape of the best response functions follow the graphs indicated by the symbols, but this is not demonstrated. Stipulating that this is the case, it seems reasonable that as K(RG) increases, K(NH) is non-decreasing. As a matter of presentation, it would be helpful if the little box with the notation had the thresholds (from m-1 through m+2) listed in the order the graphs show up. Also, the caption states "Let k* = fNH(KRG) for a given KRG." It ends with "Thus, fNH(KRG) ≥ k* as required." Or in other words, k* ≥ k*or , fNH(KRG) ≥ fNH(KRG). Also, there is no reason there will be a U = t, since the threshold is a natural number, and t is not.

Have clarified that U!=t (#40555ae).

>
> To sum up, the conjecture seems reasonable, but the support was either incorrect or needs work to be convincing.
>
> Moving on to the price of anarchy, or PoA, it is not clear to me why the definition has been "modified to allow for a maximization problem", as the inverse would have been simpler to interpret. It is further not clear why running "at 100% utilization which would not make for a robust system" is an argument against using t=100%. Let's say this causes the system to break down, but it takes seconds to reboot, in which case a fragile system may well have a greater throughput than a robust system. In fact, set the threshold to zero and the system is remarkably robust. The last sentence (p9line8-9) is not convincing since a "low PoA" is not defined, even though on the face of it, the statement seems reasonable. A more convincing argument would be that t should be the value that provides the highest throughput for a fixed level of resources, in the long run.

Have reworded this (#68afa4f).

>
> 3 Results - this section appears to be two numerical examples, solved using SAGE software. As such it is not clear how much the results generalize. However, the split into soft and hard diversion is interesting. Further, the PoA is interesting in providing a scope for the cost of a lack of coordination, but it is not clear that this is truly representative of real-world losses.

Have added a sentence to the conclusion justifying this (#3245a8a).

>
>
>
>
> Reviewer #2: This paper examines the behavior of two Critical Care Units (CCU) in a game theoretic setting.  Each hospital specifies a threshold, above which new patients will be diverted.  In some circumstances, these diverted patients will be treated at the other hospital.  The authors identify conditions under which a Nash Equilibrium exists.  They then numerically examine a couple of scenarios and evaluate the price of anarchy in this CCU setting.  While it is an interesting concept to consider CCUs in a game theoretic setting, I have a number of major concerns with the current model.
>
> 1.      There has been quite a bit of work examining state-dependent behavior in healthcare settings, and specifically in the ICU.  I would encourage the authors to carefully examine this literature.  See for example:
>
> Batt, R., C. Terwiesch. 2014. Doctors under load: An empirical study of state-dependent service times in emergency care. Working Paper, University of Wisconsin-Madison.
>
> Chan, C. W., G. Yom-Tov, G. Escobar. 2014. When to use speedup: An examination of service systems with returns. Operations Research 62 462-482.
>
> Kc, D., C. Terwiesch. 2012. An econometric analysis of patient flows in the cardiac intensive care unit. Manufacturing and Service Operations Management 14(1) 50-65.
>
> Kim, S.-H., C. W. Chan, M. Olivares, G. Escobar. 2014. ICU Admission Control: An Empirical Study of Capacity Allocation and its Implication on Patient Outcomes. Management Science, to appear.
>
> Shmueli, A., C. Sprung, E. Kaplan. 2003. Optimizing admissions to an intensive care unit. Health Care Management Science 6(3) 131-136.
>
> In particular, the Shmueli et al 2003 and Kim et al 2014 papers demonstrate exactly the diversion/rerouting discussed in this paper.

Include all of above using the literature to justify use of targets.*

>
> 2.      Issues with the service time model: I have substantial issues with the assumption that diverted patients adopt the length of stay profile of the CCUs at which they are treated.  LOS should depend more on clinical factors rather than the particular CCU of treatment.  The difference in average LOS across the hospitals is likely due to different patient mix.  The demographics and types of illnesses of the patients treated at each CCU are likely the cause of the differences.  As such, diverting one patient to another CCU will not change their profile, just the CCU of treatment. I understand that this creates more technical challenges, but this assumption seems completely unreasonable from an application stand point.

Agree with this and discuss it a bit more (possibly find some references) and have as extra work.*

>
> 3.      Models 1 and 2: How often do you see hospitals transfer critical care patients across hospitals?  It's actually much more common for patients to be rerouted to non-CCU beds within the same hospital when the CCU is full, rather than diverting them to another hospital. This is for a few reasons including 1) continuity of care. Some patients have preferences for specific hospitals because they've been treated there before and/or are familiar with the clinicians on staff. 2) Family wishes, one hospital is much closer to the residence of families, so if a patient will have an extended stay, the family prefers the patient is closer to home.  3) Temporary congestion. If a bed in the CCU is likely to open up in a reasonable time (e.g. 24 hours), a patient can be boarded in a non-CCU bed until the CCU bed becomes available. 4) Hospitals do not want to lose the revenue for treating that patient by sending him to another hospital. Patients will be sent to other hospitals if they
> require specialized care which is not available at the current hospital and/or if the wait at the current hospital is so long that it the detriment of moving the patient is less than that of making the patient wait. Keep in mind that for critical patients, sending them to another hospital via ambulance is not risk-free and can have substantial impact on the patient's physiologic state.  This makes me question the underlying model of how patients are diverted and whether it is a realistic representation of what happens in reality.

Have repeated what PoA is (#40555ae)

>
> 4.      Objective: There are many conflicting statements made throughout the paper regarding the objective.  First, on page 5, line 20, it is stated that throughput is a natural choice of utility because hospitals are paid for each served patient.  This implies that maximizing throughput would be the objective.  I have 2 issues with this. First, it is not necessarily the case that hospitals are paid for each served CCU patient.  In the US, most payments are done in a fee-for-service manner based on the DRG of the patient.  That is, there is a fixed payment depending on the DRG, which incorporates the primary condition of the patient as well as any potential complicating factors.  The payment is then based on the average cost of treating patients with that DRG. If a hospital is able to treat the patient at a lower cost, then they make more money. If they treat the patient at a higher cost, they lose money.  Thus, if a DRG does not typically include a CCU stay, the hospital
> actually has a dis-incentive to send the patient to the CCU, unless absolutely medically necessary.  Second, the presentation of the Game Theoretic model introduces a utility function with a goal to get the utilization as close to a certain target as possible. This seems contradictory to the prior statement about the desire to high throughput.  Moreover, who dictates these target utilizations?  On page 9, the authors state that 100% utilization is not desired. This contradicts the statement about the payments and high throughput, but then we see in the numerics that when t = 1, the price of anarchy is 1, which suggests that this target utilization is desirable.  In fact, I still have concerned with a target utilization of 80%.  There are a lot of factors in this model, which are not considered, but have been demonstrated to exist when the CCUs are congested.  For instance, in Kc and Terwiesch. 2012, patient LOS is reduce and readmissions are increased.  In Kim et al 2014,
> diverting patients increases readmissions and hospital LOS. None of these factors are considered in the model.  If they were, a desirable CCU utilization might be much lower to avoid such adverse effects of congestion.  There are a lot of issues here in the model and the objective. Because of this, it is very challenging to extract any insights from the analysis and numerics.

Add this details to the paper but highlight that we are looking at potential for the damage.*

>
> 5.      In Table 1, a number of parameters are provided from the data.  This brings up a number of questions:
> a.      Are there seasonal patterns in the arrival rate?  Often the arrival rates in the summer can be quite different than in the winter. This might suggest different parameter regimes for your numeric examples later.

Add as potential further work.*

> b.      Isn't the service rate in units of 1/days?

Investigate what the problem is here.*

> c.      The bed utilization target is never defined. Who dictates that .8 is the target?  What is the actual *observed* bed utilization at these CCUs?

Maybe find what observed is but also discuss where targets comes from better.*

>
> Other Comments:
>
> 1.      The last two sentences of the abstract are incredibly confusing.  What are the interests of individual hospitals? What is the goal from a social welfare perspective?  You have never defined what a utilization target is, yet you refer to it without any explanation.

Have changed wording of the last two sentences of abstracts (#6e1a5a4).

>
> 2.      In the introduction, you may want to consider removing the paragraph that starts on line 21 on page 2 as this is not really related to the presented work.

I disagree.

>
> 3.      Figure 3 is not useful.

I disagree.

>
> 4.      Page 5, line 53. The sentence that begins with "As such a Nash Equilibrium…" seems to be the concatenation of 2 separate thoughts. It's not clear how the two points connect and why they are in the same sentence.

Have clarified pure strategies (#e616939).

>
> 5.      On page 9, line 34 the authors state that if one CCU sets a threshold at 0, both units are closed.  I don't understand why this is the case. Shouldn't only 1 be closed? The other will be overloaded more often, but due to stochastic fluctuations, there must be some times when it is open.

No.

>
> 6.      Figure 7. Why don't you combine these two figures onto the same axis and demonstrate the equilibrium as done in Figure 9?

Have a single figure now (#7e3b31d).
