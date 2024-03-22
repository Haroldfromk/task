
import Foundation

// MARK: - 볼카운트를 계산

class BallCountManager {

    var ballCountModel = BallCountModel()
    var gameModel = GameModel()
    var recordManager = RecordManager()
    let recordModel = RecordModel()
    
    func getTotalCount(_ question : [Int], _ answer : [Int]) {
        
        // for문을 고차함수처럼 사용하고 싶어서 사용해보았다.
        
        answer.enumerated().forEach{ // enumerated를 사용하여 인덱스 값 생성
            (aoffset, aelement) in question.enumerated().forEach{
                (qoffset, qelement) in
                
                if aoffset == qoffset { // 문제와 내 대답의 인덱스가 서로 일치할때
                    if aelement == qelement { // 그 상태에서 값이 같다면
                        ballCountModel.ballCount["Strike"]! += 1 // strike 1 추가
                    }
                    
                } else { // 문제와 내 대답의 인덱스가 서로 다를때
                    if aelement == qelement { // 그상태에서 값이 같다면
                        ballCountModel.ballCount["Ball"]! += 1 // ball 1 추가
                    }
                    
                }
            }
        }
        
       
    }

    func getBallCount () -> Int { // 볼카운트를 가져온다.
        
        if let ballCount = ballCountModel.ballCount["Ball"] {
            return ballCount
            
        } else {
            return 0
        }
        
    }
    
    func getStrikeCount () -> Int { // 스트라이크 카운트를 가져온다.
        
        if let strikeCount = ballCountModel.ballCount["Strike"] {
            return strikeCount
            
        } else {
            return 0
        }
        
    }
    
    func resetAllBallCount () { // 한번 문제와 나의 대답을 한번 비교 한 후, 값 초기화
        
        ballCountModel.ballCount["Strike"] = 0
        ballCountModel.ballCount["Ball"] = 0
        
    }
    
    
    func checkBallCount () -> Bool {
        
        if getStrikeCount() == 3 { // 3스트라이크라면
            
            print("                HomeRun!!!!!\n")
            
            return false
            
        } else if getStrikeCount() == 0 &&  getBallCount() == 0 { // 아무것도 일치하는게 없다면
            
            print("                    Out!\n")
            
            return true
            
        } else { // 볼 스트라이크가 존재한다면
            
            print("               \(getStrikeCount()) Strike \(getBallCount()) Ball!\n")

            
            return true
        }
    }

}
