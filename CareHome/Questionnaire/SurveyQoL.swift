//
//  SurveyQoL.swift
//  CareHome
//
//  Created by Oscar on 06/02/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import Foundation
import ResearchKit
//this class is used to create the DEMQOL-CH questionnaire, and the consent form

//consent form - asks user for their signature and that they approve the use of the data for the study.
public var ConsentForm: ORKConsentDocument {
    let consentDocument = ORKConsentDocument()
    consentDocument.title = "Consent Form For Study"
    
    let consentSectionTypes: [ORKConsentSectionType] = [.overview]
    
    let consentSections: [ORKConsentSection] = consentSectionTypes.map { contentSectionType in
        let consentSection = ORKConsentSection(type: contentSectionType)
        consentSection.summary = "This is a study about the assessment of the quality of life of patients in care homes."
        consentSection.content = "In this study you will be asked 32 questions. You should answer on the behalf of the patient. A QoL score will be calculated based on the answers you give, and is displayed on a graph."
        return consentSection
    }

    consentDocument.sections = consentSections
    
    consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
    
    return consentDocument
}


//creates an ordered task - this contains the consent form and questionnaire
//it displays the screens in the order that they are added to the 'steps' variable.
public var SurveyQoL: ORKOrderedTask {
    
//    answers to questions are assigned a value
    let questionChoices = [ORKTextChoice(text: "a lot", value: 1 as NSNumber),
    ORKTextChoice(text: "quite a bit", value: 2 as NSNumber),
    ORKTextChoice(text: "a little", value: 3 as NSNumber),
    ORKTextChoice(text: "not at all", value: 4 as NSNumber)]
    
    
    let questionChoicesReverse = [ORKTextChoice(text: "a lot", value: 4 as NSNumber),
      ORKTextChoice(text: "quite a bit", value: 3 as NSNumber),
      ORKTextChoice(text: "a little", value: 2 as NSNumber),
      ORKTextChoice(text: "not at all", value: 1 as NSNumber)]
    
//    variable used to contain all the steps of the consent form and questionnaire.
    var steps = [ORKStep]()
    
    //Consent Document before starting the survey
    let consentForm = ConsentForm
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentForm)
    steps += [visualConsentStep]

    //include the signature and set data for the consent form - reason to why consent is needed and what data is collected.
    let signature = consentForm.signatures!.first!

    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentForm)

    reviewConsentStep.text = "Review Consent!"
    reviewConsentStep.reasonForConsent = "Consent to join study"

    steps += [reviewConsentStep]
    
    //SUMMARY ENDING TO THE QUESTIONNAIRE
    let summaryStep2 = ORKCompletionStep(identifier: "SummaryStep2")
    summaryStep2.title = "Complete!"
    summaryStep2.text = "Thank you very much for agreeing to take part in the study! The questionnaire will now begin."
    steps += [summaryStep2]
    
    //Introduction to the Survey
    let instructionStep = ORKInstructionStep(identifier: "IntroductionStep")
    instructionStep.title = "QoL Survey Instructions"
    instructionStep.text = "I would like to ask you about the resident's life, as you are the person who knows him/her best. There are no right or wrong answers. Just give the answer that best describes how the resident has felt in the last week. If possible try and give the answer that you think the resident would give. Don't worry if some questions appear not to apply to the resident. We have to ask the same questions of everybody. The survey will take about 20-30 minutes to complete."
    steps += [instructionStep]
    
    //Instructions for first set of questions
    let secondInstruction = ORKInstructionStep(identifier: "FirstSetOfQuestions")
    secondInstruction.text = "For all the questions I'm going to ask you, I want you to think about the last week. First I'm going to ask you about the resident's FEELINGS."
    steps += [secondInstruction]
    
    //First set of questions title
    let questionStepTitle = "In the LAST WEEK,"
    
    //First question
    let question = "would you say that the resident has felt CHEERFUL?"
    let answerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoicesReverse)
    let questQuestionStep = ORKQuestionStep(identifier: "FirstQuestion", title: questionStepTitle, question: question, answer: answerFormat)
    questQuestionStep.isOptional = false
    steps += [questQuestionStep]
    
    //Second question
    let question1 = "would you say that the resident has felt WORRIED or ANXIOUS?"
    let format : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep = ORKQuestionStep(identifier: "SecondQuestion", title: questionStepTitle, question: question1, answer: format)
    questionStep.isOptional = false
    steps += [questionStep]
    
    //third question
    let question2 = "would you say that the resident has felt fustrated?"
    let answerFormat3 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep3 = ORKQuestionStep(identifier: "ThirdQuestion", title: questionStepTitle, question: question2, answer: answerFormat3)
    questionStep3.isOptional = false
    steps += [questionStep3]
    
    //fourth question
    let question3 = "would you say that the resident has felt full of energy?"
    let answerFormat4 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoicesReverse)
    let questionStep4 = ORKQuestionStep(identifier: "FourthQuestion", title: questionStepTitle, question: question3, answer: answerFormat4)
    questionStep4.isOptional = false
    steps += [questionStep4]
    
    
    //Fifth question
    let question4 = "would you say that the resident has felt sad?"
    let answerFormat5 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep5 = ORKQuestionStep(identifier: "FifthQuestion", title: questionStepTitle, question: question4, answer: answerFormat5)
    questionStep5.isOptional = false
    steps += [questionStep5]
    
    //Sixth question
    let question6 = "would you say that the resident has felt content?"
    let answerFormat6 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoicesReverse)
    let questionStep6 = ORKQuestionStep(identifier: "SixthQuestion", title: questionStepTitle, question: question6, answer: answerFormat6)
    questionStep6.isOptional = false
    steps += [questionStep6]
    
    //Seventh question
    let question7 = "would you say that the resident has felt distressed?"
    let answerFormat7 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep7 = ORKQuestionStep(identifier: "SeventhQuestion", title: questionStepTitle, question: question7, answer: answerFormat7)
    questionStep7.isOptional = false
    steps += [questionStep7]
    
    //eigth question
    let question8 = "would you say that the resident has felt lively?"
    let answerFormat8 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoicesReverse)
    let questionStep8 = ORKQuestionStep(identifier: "EigthQuestion", title: questionStepTitle, question: question8, answer: answerFormat8)
    questionStep8.isOptional = false
    steps += [questionStep8]
    
    //Ninth question
    let question9 = "would you say that the resident has felt irritable?"
    let answerFormat9 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep9 = ORKQuestionStep(identifier: "NinthQuestion", title: questionStepTitle, question: question9, answer: answerFormat9)
    questionStep9.isOptional = false
    steps += [questionStep9]
    
    //Tenth question
    let question10 = "would you say that the resident has felt fed-up?"
    let answerFormat10 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep10 = ORKQuestionStep(identifier: "TenthQuestion", title: questionStepTitle, question: question10, answer: answerFormat10)
    questionStep10.isOptional = false
    steps += [questionStep10]
    
    //Eleventh question
    let question11 = "would you say that the resident has felt that he/she has things to look forward to?"
    let answerFormat11 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep11 = ORKQuestionStep(identifier: "EleventhQuestion", title: questionStepTitle, question: question11, answer: answerFormat11)
    questionStep11.isOptional = false
    steps += [questionStep11]
    
    
    //Instructions for second set of questions
    let secondSetInstruction = ORKInstructionStep(identifier: "SecondSetOfQuestions")
    secondSetInstruction.text = "Next, I'm going to ask you about the resident's MEMORY."
    steps += [secondSetInstruction]
    

    
    //12 question
    let question12 = "How WORRIED would you say the resident has been about his/her memory in general?"
    let answerFormat12 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep12 = ORKQuestionStep(identifier: "12Question", title: questionStepTitle, question: question12, answer: answerFormat12)
    questionStep12.isOptional = false
    steps += [questionStep12]
    
    
    //13 question
    let question13 = "How WORRIED would you say that resident has been about forgetting things that happened a long time ago?"
    let answerFormat13 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep13 = ORKQuestionStep(identifier: "13Question", title: questionStepTitle, question: question13, answer: answerFormat13)
    questionStep13.isOptional = false
    steps += [questionStep13]
    
    //14 question
    let question14 = "How WORRIED would you say the resident has been about forgetting things that happened recently?"
    let answerFormat14 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep14 = ORKQuestionStep(identifier: "14Question", title: questionStepTitle, question: question14, answer: answerFormat14)
    questionStep14.isOptional = false
    steps += [questionStep14]
    
    //15 question
    let question15 = "How WORRIED would you say the resident has been about forgetting people's names?"
    let answerFormat15 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep15 = ORKQuestionStep(identifier: "15Question", title: questionStepTitle, question: question15, answer: answerFormat15)
    questionStep15.isOptional = false
    steps += [questionStep15]
    
    //16 question
    let question16 = "How WORRIED would you say the resident has been about forgetting where he/she is?"
    let answerFormat16 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep16 = ORKQuestionStep(identifier: "16Question", title: questionStepTitle, question: question16, answer: answerFormat16)
    questionStep16.isOptional = false
    steps += [questionStep16]
    
    
    //12=7 question
    let question17 = "How WORRIED would you say the resident has been about forgetting what day it is?"
    let answerFormat17 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep17 = ORKQuestionStep(identifier: "17Question", title: questionStepTitle, question: question17, answer: answerFormat17)
    questionStep17.isOptional = false
    steps += [questionStep17]
    
    
    //18 question
    let question18 = "How WORRIED would you say the resident has been about his/her thoughts being muddled?"
    let answerFormat18 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep18 = ORKQuestionStep(identifier: "18Question", title: questionStepTitle, question: question18, answer: answerFormat18)
    questionStep18.isOptional = false
    steps += [questionStep18]
    
    //19 question
    let question19 = "How WORRIED would you say the resident has been about difficulty making decisions?"
    let answerFormat19 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep19 = ORKQuestionStep(identifier: "19Question", title: questionStepTitle, question: question19, answer: answerFormat19)
    questionStep19.isOptional = false
    steps += [questionStep19]
    
    //20 question
    let question20 = "How WORRIED would you say the resident has been about making him/herself understood?"
    let answerFormat20 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep20 = ORKQuestionStep(identifier: "20Question", title: questionStepTitle, question: question20, answer: answerFormat20)
    questionStep20.isOptional = false
    steps += [questionStep20]
    
    //Instructions for third set of questions
       let thirdSetInstruction = ORKInstructionStep(identifier: "ThirdSetOfQuestions")
        thirdSetInstruction.text = "Now, I'm going to ask about the resident's EVERYDAY LIFE."
       steps += [thirdSetInstruction]
    
    //21 question
    let question21 = "How WORRIED would you say the resident has been about keeping him/herself clean (e.g. washing and bathing)?"
    let answerFormat21 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep21 = ORKQuestionStep(identifier: "21Question", title: questionStepTitle, question: question21, answer: answerFormat21)
    questionStep21.isOptional = false
    steps += [questionStep21]
    
    //22 question
    let question22 = "How WORRIED would you say the resident has been about keeping him/herself looking nice?"
    let answerFormat22 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep22 = ORKQuestionStep(identifier: "22Question", title: questionStepTitle, question: question22, answer: answerFormat22)
    questionStep22.isOptional = false
    steps += [questionStep22]
    
    
    //23 question
    let question23 = "How WORRIED would you say the resident has been about getting what he/she wants from the shops?"
    let answerFormat23 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep23 = ORKQuestionStep(identifier: "23Question", title: questionStepTitle, question: question23, answer: answerFormat23)
    questionStep23.isOptional = false
    steps += [questionStep23]
    
    //24 question
    let question24 = "How WORRIED would you say the resident has been about using money to pay for things?"
    let answerFormat24 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep24 = ORKQuestionStep(identifier: "24Question", title: questionStepTitle, question: question24, answer: answerFormat24)
    questionStep24.isOptional = false
    steps += [questionStep24]
    
    //25 question
    let question25 = "How WORRIED would you say the resident has been about looking after his/her finances?"
    let answerFormat25 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep25 = ORKQuestionStep(identifier: "25Question", title: questionStepTitle, question: question25, answer: answerFormat25)
    questionStep25.isOptional = false
    steps += [questionStep25]
    
    //26 question
    let question26 = "How WORRIED would you say the resident has been about things taking longer than they used to?"
    let answerFormat26 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep26 = ORKQuestionStep(identifier: "26Question", title: questionStepTitle, question: question26, answer: answerFormat26)
    questionStep26.isOptional = false
    steps += [questionStep26]
    
    //27 question
    let question27 = "How WORRIED would you say the resident has been about getting in touch with people?"
    let answerFormat27 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep27 = ORKQuestionStep(identifier: "27Question", title: questionStepTitle, question: question27, answer: answerFormat27)
    questionStep27.isOptional = false
    steps += [questionStep27]
    
    //28 question
    let question28 = "How WORRIED would you say the resident has been about not having enough company?"
    let answerFormat28 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep28 = ORKQuestionStep(identifier: "28Question", title: questionStepTitle, question: question28, answer: answerFormat28)
    questionStep28.isOptional = false
    steps += [questionStep28]
    
    
    //29 question
    let question29 = "How WORRIED would you say the resident has been about not being able to help other people?"
    let answerFormat29 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep29 = ORKQuestionStep(identifier: "29Question", title: questionStepTitle, question: question29, answer: answerFormat29)
    questionStep29.isOptional = false
    steps += [questionStep29]
    
    //30 question
    let question30 = "How WORRIED would you say the resident has been about not playing a useful part in things?"
    let answerFormat30 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep30 = ORKQuestionStep(identifier: "30Question", title: questionStepTitle, question: question30, answer: answerFormat30)
    questionStep30.isOptional = false
    steps += [questionStep30]
    
    //31 question
    let question31 = "How WORRIED would you say the resident has been about his/her physical health?"
    let answerFormat31 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoices)
    let questionStep31 = ORKQuestionStep(identifier: "31Question", title: questionStepTitle, question: question31, answer: answerFormat31)
    questionStep31.isOptional = false
    steps += [questionStep31]
   
    
    
    //Instructions for third set of questions
    let fourthSetInstruction = ORKInstructionStep(identifier: "FourthSetOfQuestions")
    fourthSetInstruction.text = "We've already talked about lots of things: The resident's feelings, memory and everyday life. The last questions includes:"
    steps += [fourthSetInstruction]
    
    //32 question
    let question32 = "Thinking about ALL of these things in the LAST WEEK, how would you say the resident would rate his/her QUALITY OF LIFE overall?"
    let answerFormat32 : ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: questionChoicesReverse)
    let questionStep32 = ORKQuestionStep(identifier: "32Question", title: questionStepTitle, question: question32, answer: answerFormat32)
    questionStep32.isOptional = false
    steps += [questionStep32]
    
    //SUMMARY ENDING TO THE QUESTIONNAIRE
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Complete!"
    summaryStep.text = "Thank you very much for the taking the survey, the QoL score will be calculated now and presented to you."
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "SurveyQoL", steps: steps)
}
