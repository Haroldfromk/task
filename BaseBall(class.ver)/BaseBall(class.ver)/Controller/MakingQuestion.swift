

import Foundation

// MARK: - 문제 생성

class MakingQuestion {
    
    var gameModel = GameModel()
    var questionModel = QuestionModel()
    
    func makeQuestion() -> [Int] {
        
        // initialize
        gameModel.question = [] // 재시작의 경우를 고려 초기화
        questionModel.numbers = (0...9).map{$0} // 0~9까지 배열을 만들어준다
        questionModel.quesMaking = true
        
        // making question
        while questionModel.quesMaking {
            
            var a = 0
            
            a = questionModel.numbers.randomElement()! // 랜덤의 수를 하나 배열에서 추출
            gameModel.question.append(a) // 문제에 해당 값을 추가
            questionModel.numbers.remove(at:questionModel.numbers.firstIndex(of: a)!) // 추가한값은 0~9까지의 배열에서 제거 (중복을 피하기위해)
            
            if gameModel.question[0] == 0 { // 처음에 0이 들어가면
                gameModel.question = [] // 빈배열로 초기화
                continue
            }
            
            if gameModel.question.count == 3 { // 3자리의 수가 만들어지면
                questionModel.quesMaking = false
            }
            
        }
        
        return gameModel.question // 문제 리턴
    }
    
}
