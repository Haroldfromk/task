
import Foundation

// MARK: - 게임 큰틀에 대해 구현

class BaseballGame{
    
    var gameModel = GameModel()
    var recordModel = RecordModel()
    
    let recordManager = RecordManager()
    let makingQuestion = MakingQuestion()
    let ballCountManager = BallCountManager()
    let inputManager = InputManager()
    
    
    func start () {
        
        // 기록 데이터 초기화.
        recordModel.ansCount = 0
        recordModel.scoreArray = []
        
        while gameModel.gameTitle { // gameTitle이 true일때 무한 반복
            
            print("               ⚾️ Play Ball ⚾️")
            print(" [1]. Game Start! [2]. Game Record [3]. Exit ")
            
            let titleInput = Int(readLine()!)
            
            switch titleInput { // 유져의 값에 따라 각각 다른 기능 실행
                
            case 1 : // 1을 눌렀을때
                
                gameModel.question = makingQuestion.makeQuestion() // 문제 생성 시작
                
                gameModel.gameStart = true // 실제 게임을 실행할 while문의 조건을 true로 다시 바꾼다
                                                  // 게임이끝나면 false로 바뀌기 때문.
                
                recordModel.ansCount = recordManager.resetCount() // 게임 재시작의 경우도 고려하여 시도횟수 0으로 초기화
                
                while gameModel.gameStart {
                    
                    gameModel.ansCheck = true // 위의 내용과 이하동문
                    
                    while gameModel.ansCheck { // ansCheck를 통해 유져가 3자리의 숫자만 입력하게한다.
                                                     // 3자리를 입력했을때 false로 빠져나간다.
                        
                        print("           Please Enter 3 Numbers")
                        print(gameModel.question)
                        
                        let input = readLine() // 유져의 입력값을 받는다.
                        
                        if let input = input { // 옵셔널 바인딩
                            
                            if input.filter({$0.isNumber}).count == input.count {
                                // 내가 입력한 값에 혹시라도 문자가 있는지 없는지 확인 숫자만 이루어진다면 양변의 값은 같다.
                                
                                gameModel.answer = input.map{Int(String($0))!}
                                
                                let result = inputManager.answerCheck(answer: gameModel.answer, number: recordModel.ansCount)
                                // 유져가 입력한 값을 검증한다.
                                
                                gameModel.ansCheck = result.0
                                recordModel.ansCount = result.1
                                
                            }
                            else { // 유져가 숫자가 아닌 값을 입력했을때.
                                
                                print("      Please Enter the Number Correctly")
                                recordModel.ansCount = recordManager.increaseAnsCount(number: recordModel.ansCount)
                                // 시도 횟수 1증가.
                            }
                            
                        } else { // 옵셔널 바인딩에 실패했을경우
                            
                            print("Exception Detected")
                            break
                            
                        }
                        
                    }
                    
                    
                    
                    ballCountManager.resetAllBallCount() // 볼카운트를 초기화
                    ballCountManager.getTotalCount(gameModel.question, gameModel.answer) // 문제와 내가 입력한 값을 통해 볼카운트를 구한다.
                    
                    gameModel.gameStart = ballCountManager.checkBallCount() // 현재 볼카운트를 체크하여 해당 조건에따라 결과를 다르게함.
                    
                    
                }
                
                recordModel.scoreArray = recordManager.saveCount(array: recordModel.scoreArray, count: recordModel.ansCount) // 게임 종료 후 현재 값을 배열에 저장해준다.
                
                
            case 2 : // 메인화면에서 2를 입력했을때
                
                recordManager.showRecord(array: recordModel.scoreArray) // 현재 배열을 가져와서 기록을 보여준다.
                
            case 3 : // 메인화면에서 3을 입력했을때
                
                print("                  Good Bye👋")
                gameModel.gameTitle = false
                
            default : // 그 외의 숫자나 문자를 입력했을때
                
                print("      Please Enter the Number Correctly\n")
                
            }
        }
    }
    
}

