
import Foundation

// MARK: - 입력 담당

class InputManager {
    
    let recordManager = RecordManager()
    
    func answerCheck (answer : [Int], number : Int) -> (Bool, Int) {
        
        if answer.count != 3 { // 3자리가 아닌 수를 입력했을때
            
            print("         Please Enter 3 Numbers again.\n")
            var Number = number
            Number = recordManager.increaseAnsCount(number: Number) // 1번 시도했으므로 시도 횟수 1 증가
     
            return (true, Number)
            
        } else {
            
            if answer[0] == answer [1] || answer[0] == answer [2] || answer[1] == answer [2] { // 중복 숫자를 입력했을 경우
                
                print("         Duplicated numbers detected!\n         Please Enter 3 Numbers again.\n")
                var Number = number
                Number = recordManager.increaseAnsCount(number: Number) // 1번 시도했으므로 시도 횟수 1 증가
                
                return (true, Number)
                
            } else {
                
                if answer[0] == 0 { // 처음에 0을 입력한다면
                    
                    print("          First number must not be 0\n         Please Enter 3 Numbers again.\n")
                    var Number = number
                    Number = recordManager.increaseAnsCount(number: Number) // 1번 시도했으므로 시도 횟수 1 증가
                    
                    return (true, Number)
                    
                } else { // 제대로 된 값을 입력한다면
                    
                    var Number = number
                    Number = recordManager.increaseAnsCount(number: Number) // 1번 시도했으므로 시도 횟수 1 증가
                    
                    return (false, Number)
                    
                }
                
            }
        }
        
    }
    
}
