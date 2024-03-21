
import Foundation

// MARK: - 경기 기록을 담당 (총 몇판, 한판당 성공까지 시도 횟수)

class RecordManager {
     
    var recordModel = RecordModel()
    
    // 숫자 1씩 증가
    func increaseAnsCount (number : Int) -> Int {
        var Number = number
        Number += 1
        return Number
    }
    
    // 현재의 카운트를 배열에 저장
    func saveCount (array : [Int], count : Int) -> [Int] {
        var scoreArray = array
        scoreArray.append(count)
        return scoreArray
    }
    
    func resetCount () -> Int {
        
        return 0
    }
    
    // 현재 기록을 본다.
    func showRecord (array : [Int]) {
        let scoreArray = array
        
        if scoreArray.count != 0 { // 게임을 한판이라도 했다면
            
            print("         <<<<< Game Records >>>>>")
            for i in 0 ..< scoreArray.count {
                print("           \(i+1) Game, Attempts : \(scoreArray[i])\n")
            }
            
        } else { // 한판도 안했다면
            
            print("          There is no Game Record.\n")

        }
    }
    
}
