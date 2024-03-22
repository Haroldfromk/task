
// MARK: - Lv1
class Calculator {
    
    func addOperation (_ x: Int, _ y: Int) {
        print(x+y)
    }
    
    func substractOperation (_ x: Int, _ y: Int) {
        print(x-y)
    }
    
    func multiOperation (_ x: Int, _ y: Int) {
        print(x*y)
    }
    
    func divideOperation (_ x: Int, _ y: Int) {
        print(x-y)
    }
    
}

// MARK: - Lv2
class Calculator {
    
    func addOperation (_ x: Int, _ y: Int) {
        print(x+y)
    }
    
    func substractOperation (_ x: Int, _ y: Int) {
        print(x-y)
    }
    
    func multiOperation (_ x: Int, _ y: Int) {
        print(x*y)
    }
    
    func divideOperation (_ x: Int, _ y: Int) {
        print(x-y)
    }
    
    func modOperation (_ x: Int, _ y: Int) {
        print(x%y)
    }
    
}


//MARK: - Lv3
class Calculator {
    
    let add = AddOperation()
    let substract = SubstractOperation()
    let multiply = MutiplyOperation()
    let divide = DivideOperation()
    let mod = ModOperation()
    
}

class AddOperation  {
    func operation (first : Int, second : Int) {
        print(first + second)
    }
    func operation (first : Int, second : Double) {
        print(Double(first) + second)
    }
    func operation (first : Double, second : Int) {
        print(first + Double(second))
    }
    func operation (first : Double, second : Double) {
        print(first + second)
    }
}

class SubstractOperation {
    func operation (first : Int, second : Int) {
        print(first - second)
    }
    func operation (first : Int, second : Double) {
        print(Double(first) - second)
    }
    func operation (first : Double, second : Int) {
        print(first - Double(second))
    }
    func operation (first : Double, second : Double) {
        print(first - second)
    }
}

class MutiplyOperation {
    func operation (first : Int, second : Int) {
        print(first * second)
    }
    func operation (first : Int, second : Double) {
        print(Double(first) * second)
    }
    func operation (first : Double, second : Int) {
        print(first * Double(second))
    }
    func operation (first : Double, second : Double) {
        print(first * second)
    }
}

class DivideOperation  {
    func operation (first : Int, second : Int) {
        print(first / second)
    }
    func operation (first : Int, second : Double) {
        print(Double(first) / second)
    }
    func operation (first : Double, second : Int) {
        print(first / Double(second))
    }
    func operation (first : Double, second : Double) {
        print(first / second)
    }
}

class ModOperation {
    func operation (first : Int, second : Int) {
        print(first % second)
    }
    func operation (first : Int, second : Double) {
        print(Double(first).truncatingRemainder(dividingBy:second))
    }
    func operation (first : Double, second : Int) {
        print(first.truncatingRemainder(dividingBy: Double(second)))
    }
    func operation (first : Double, second : Double) {
        print(first.truncatingRemainder(dividingBy: second))
    }
}


// MARK: - Lv4 (without protocol)
class Calculator {
    
    let add = AddOperation()
    let substract = SubtractOperation()
    let multiply = MultiplyOperation()
    let divide = DivideOperation()
    let mod = ModOperation()
    
}


class AbstractOperation {
    
    func operation(first: Double, second: Double) { }
    
}

class AddOperation: AbstractOperation {
    
    override func operation(first: Double, second: Double) {
        print(first + second)
    }
}

class SubtractOperation: AbstractOperation {
    override func operation(first: Double, second: Double) {
        print(first - second)
    }
}

class MultiplyOperation: AbstractOperation {
    override func operation(first: Double, second: Double) {
        print(first * second)
    }
}

class DivideOperation: AbstractOperation {
    override func operation(first: Double, second: Double) {
        print(first / second)
    }
}

class ModOperation: AbstractOperation {
    override func operation(first: Double, second: Double) {
        print(first.truncatingRemainder(dividingBy: second))
    }
}

// MARK: - Lv4 (with protocol)

protocol operate {
    func operation (first: Double, second: Double)
}

class Calculator {

    let add = AddOperation()
    let substract = SubtractOperation()
    let multiply = MultiplyOperation()
    let divide = DivideOperation()
    let mod = ModOperation()

}

// Don't use this class
//class AbstractOperation {
//
//    func operation(first: Double, second: Double) { }
//
//}

class AddOperation: operate {

     func operation(first: Double, second: Double) {
        print(first + second)
    }
}

class SubtractOperation: operate {
     func operation(first: Double, second: Double) {
        print(first - second)
    }
}

class MultiplyOperation: operate {
     func operation(first: Double, second: Double) {
        print(first * second)
    }
}

class DivideOperation: operate {
     func operation(first: Double, second: Double) {
        print(first / second)
    }
}

class ModOperation: operate {
     func operation(first: Double, second: Double) {
        print(first.truncatingRemainder(dividingBy: second))
    }
}

