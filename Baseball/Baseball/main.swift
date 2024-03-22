
import Foundation

// MARK: - Define Parameters

var numbers : [Int] = []
var question : [Int] = []
var answer : [Int] = []
var scoreArray : [Int] = []
var ballCount : [String : Int] = [:]

var gameTitle : Bool = true
var gameStart : Bool = true
var gameMaking : Bool = true

var gameCount : Int = 0
var scoreCount : Int = 0
var strike : Int = 0
var ball : Int = 0


// MARK: - Making Question

func makeQuestion () -> [Int] {
    numbers = (0...9).map{$0} // for creating random numbers
    question = [] // init array
    
    while gameMaking {
        var a = 0
        a = numbers.randomElement()!
        question.append(a)
        numbers.remove(at:numbers.firstIndex(of: a)!) // to avoid duplicated numbers
        
        if question[0] == 0 { // to avoid the first of number which is 0
            question = [] // init array
            continue
        }
        
        if question.count == 3 { // finishing making array
            gameMaking = false
        }
    }
    
    return question
}

// MARK: - Comparing answer and question & Get ball count

func getBallCount(_ question : [Int], _ answer : [Int]) -> [String : Int]{
    
    // init strike & ball count
    strike = 0
    ball = 0
    ballCount = ["Strike": 0, "Ball" : 0 ]
    
    for i in question.indices {
        for j in question.indices {
            if i == j {
                if answer[i] == question[j] { // same position
                    strike += 1
                }
            } else {
                if answer[i] == question[j] { // different position
                    ball += 1
                }
            }
        }
    }
    
    ballCount["Strike"] = strike
    ballCount["Ball"] = ball
    
    return ballCount
}


// MARK: - Game Logic

func gamePart () {
    while gameStart {
        
        print("숫자를 입력해주세요.")
        
        print(question)
        
        let input = Int(readLine()!) // to get user's answer
        
        if let input = input { // if type is Int
            answer = String(input).map{Int(String($0))!}
            
            if answer.count != 3 { // when count is not 3
                print("3자리의 숫자가 아닙니다. 3자리로 입력해주세요\n")
                scoreCount += 1 // count up
                continue
            }
            
            if answer[0] == answer [1] || answer[0] == answer [2] || answer[1] == answer [2] { // when duplicated numbers extist
                print("중복된 수가 존재 합니다. 다시 입력해주세요\n")
                scoreCount += 1 // count up
                continue
            }
            
        } else { // if type is not Int
            print("숫자가 아닌 값이 입력 되었습니다. 숫자만 입력해주세요\n")
            scoreCount += 1 // count up
            continue
        }
        
        scoreCount += 1 // count up
        
        ballCount = getBallCount(question, answer)
        
        if ballCount["Strike"] == 3 {
            print("<<<<<축하합니다 정답입니다>>>>>.\n")
            gameCount += 1
            scoreArray.append(scoreCount)
            gameStart = false
        } else if strike == 0 && ball == 0 {
            print("Nothing\n")
        } else {
            print("현재 \(ballCount["Strike"] ?? 0) Strike \(ballCount["Ball"] ?? 0) Ball 입니다.\n")
        }
    }
}



// MARK: - Game Main Title

while gameTitle {
    
    // init game logic
    gameStart = true
    gameMaking = true
    
    scoreCount = 0
    
    print("<<<<<게임을 시작합니다>>>>>") // for notification when app starts
    print("1. 게임 시작하기. 2. 게임 기록 보기 3. 종료하기")
    
    let titleInput = Int(readLine()!)
    
    if let titleInput = titleInput { // if type is Int
        
        if titleInput == 1 {
            
            question = makeQuestion() // Make question
            gamePart() // game start
            
            
        } else if titleInput == 2 {
            
            if gameCount != 0 {
                
                print("<게임 기록 보기>")
                
                for i in 0..<gameCount {
                    print("\(i+1) 번째 게임, 시도 횟수 : \(scoreArray[i])")
                }
                print("")
                continue
                
            } else { // when user type 2, before starting game
                print("게임 기록이 없습니다.\n")
                continue
            }
            
        } else if titleInput == 3 {
            print("종료합니다")
            gameTitle = false
            
        } else { // except for 1,2,3
            print("1, 2, 3 숫자만 입력하세요\n")
        }
        
    } else{ // if type is not Int
        print("1, 2, 3 숫자만 입력하세요\n")
    }
}
