# SentimentAnalysis
Sentiment Analysis is the most prominent branch of natural language processing. It deals with the text classification in order to determine the intention of the author of the text. The intention can be of positive or negative type.
We use the holdout method (70% for training and 30% for testing) for the evaluation. Firstly, we obtained training and testing files using given positive and negative text files which have 730 comments. The methods and techniques used in emotional analysis are explained in detail below.

A.	Text Preprocessing

Text preprocessing consists of three steps.

A.1.	Tokenization

			The first data given is the type of two separate text files. These text files are of two types, positive and negative. There are 730 comments in each text file. At this stage, each sentence was separated into words by using each comment. These words are expressed as tokens. 

A.2.	Stop-Word Removal

			Stop-words are words that pass through almost every sentence and are not worthy of classification. Stop-words are usually shorter than 3 letters in Turkish. At this stage, words shorter than 3 letters in length are not considered. 

A.3.	Stemming

			Stemming is the process of reducing inflected (or sometimes derived) words to their word stem, base or root form in linguistic morphology and information retrieval [5]. There are many methods for stemming. We used fixed-prefix as the stemming method. When using fixed-prefix we only got the first 5 letters of words that are more than 5 letters because words are generally 5 letters in Turkish. The shorter words remain the same.

B.	Text Transformation

We measure the importance of the words obtained in this step. We calculated the TF-IDF values of each word to measure the importance of these words. The term frequency tft,d of term t in document d is defined as the number of times that t occurs in d [6]. The document frequency df of term t is defined as the number of times that t that t occurs in how many documents d. But, we use inverse document frequency idf because rare terms are more informative than frequent terms [6].  

In this stage, every comment is considered as a document. A table was created after calculating the tf-idf values of each word. Using this table, all tf-idf values of each word were added and obtained a weighted score w. Then, these scores were sorted as descending and the first 3000 words were taken.

C.	Feature Selection

Feature selection is an essential topic in the field of pattern recognition. The feature selection strategy has a direct influence on the accuracy and processing time of pattern recognition applications [8]. 
Given text documents contain billions of words and document vectors would contain billions of dimensions. As a result, many algorithms cannot handle huge number of terms. So, we use a feature selection method to reduce these terms and to obtain precious terms for classification of comments.  
There are many different feature selection methods such as chi-square, information gain, mutual information, odds ratio, relevancy score etc. Usually, in natural language applications, information gain is used to select features. Information gain measures the information obtained for category prediction by knowing the presence or absence of a term in a document [9]. Also, information gain is calculated for each term and the best n terms are selected.

We need to calculate estimating probabilities of some variables to calculate information gain for each term.
P(ci) is the probability of category i. In this project, there are two categories as positive and negative. P(positive) and P(negative) are 0.5 because there are equal number of comments for each category.
P(t) is the probability of a term t. In this project, terms are fetched from comments and it calculated by document frequency of the term over total comment size.
P(~t) is the probability of the absence of t. That value are calculated by using 1-P(t).
P(ci | t) is the probability of category i if term t is in the document which is in category i. 
P(positive | term) = How many positive comments have this term / Document frequency of term
P(ci | ~t) is the probability of category i if term t is not in the document which is in category i.
P(positive | ~term) = How many positive comments do not have this term / (Total Document Size - Document frequency of term)
We calculated information gain values for each term and sorted these values in descending order and the first 500 terms are selected. These terms are more precious and more specific to classify the given comments.

D.	Classification

Classification is an important problem in pattern recognition systems. So, there are a lot of different works and applications about classification such as topic classification, sentiment analysis, spam e-mail filtering, spam SMS filtering, author identification etc. [9]. 
The task is to assign a comment (document) to one category (positive or negative), based on its contents (words) in this sentiment analysis project. 
There are many different classifier for classification such as rocchio methods, probabilistic classifiers (Naïve Bayes), decision tree classifiers, neural networks, example-based classifiers (k-NN), support vector machines etc. [9]. In this project, Naive Bayes Classification method is used because 
Naïve Bayes is one of the most basic classification methods of machine learning methods [10]. The most known feature of this method is to evaluate events by doing probability calculations [10].
We use features that came from information gain calculations. We calculate probability of being positive and negative for each feature. Then, we use comments that in testing set. Each word of these comments compare features and if there are features in these comment, each feature probability value multiply with each other. If positive probability multiplication bigger than negative probability multiplication of a testing comment, this comment’s class is positive and vice versa.  

E.	Evaluation

In this stage, precision, recall, accuracy and F-score are used for performance assessment. True Positive (TP), True Negative (TN), False Positive (FP) and False Negative (FN) are used for these assessments. True Positive means that a word is actual positive and is predicted positive. False Positive means that a word is actual negative and is predicted positive. False Negative means that a word is actual positive and is predicted negative. True Negative means that a word is actual negative and is predicted negative.

Precision is used to measure exactness, whereas recall is a measure of completeness [11].
Precision = TP / (TP + FP)
Recall = TP / (TP + FP)
Accuracy is the proportion of correctly classified examples to the total number of examples [11].
Accuracy = (TP + TN) / (TP + TN + FP + FN)
F-Score is the harmonic mean of precision and recall. This gives a score that is a balance between precision and recall [11].
F-Score = (2 * Precision * Recall) / (Precision + Recall)

	CONCLUSION

In sentiment analysis, it is difficult for human to predict the movie review. To resolve this, the document sentiment classification is used in the existing system. It determines whether an opinion document (movie comment) is positive or negative sentiment. 
In this sentiment analysis project, we use different methods at each step. Finally, we achieve accuracy of 83.37% and F-Score of 83.18%. These values are acceptable for sentiment analysis classification. 

REFERENCES


[1]	Dan Jurafsky, “Stanford University Sentiment Analysis Lecture“, Stanford Universty

[2]	Bo Pang and Lillian Lee, “Opinion mining and sentiment analysis”, Foundations and Trends in Information Retrieval Vol. 2, No 1-2 (2008)

[3]	“Thumbs Up or Thumbs Down Semantic Orientation Applied to Unsupervised Classification of Reviews”. Proceedings of the Association for Computational Linguistics. pp. 417–424 

[4]	Sentiment Analysis (Opinion Mining), https://en.wikipedia.org/wiki/Sentiment_analysis

[5]	Stemming, https://en.wikipedia.org/wiki/Stemming

[6]	Christopher D. Manning, Prabhakar Raghavan, Hinrich Schütze, “Scoring, Term Weighting and the Vector Space Model”, An Introduction to Information Retrieval

[7]	Bag of Words & TF-IDF, https://deeplearning4j.org/bagofwords-tf-idf

[8]	Segios Theodoridis, Konstantinos Koutroumbas, “Features, Feature Vectors and Classifires”, Pattern Recognation 2nd Edition

[9]	Segios Theodoridis, Konstantinos Koutroumbas, “Text Classifications”, Pattern Recognation 2nd Edition

[10] Fırat Akba, “Assessment of Feature Selection Metrics for Sentiment Analysis: Turkish Movie Reviews”, Haccettepe Üniversitesi, 2008

[11] Anju Tiwari, Rashmi Shrivas, “Sentiment Analysis and Classification with Feature Reduction using Principal Component Analysis Algorithm on Textual Reviews”, MATS University 
