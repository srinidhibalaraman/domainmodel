import Darwin
struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount : Int
    var currency : String
    
    public func convert(_ mon : String) -> Money {
        if (mon == "USD") {
            if (self.currency == "GBP") {
                return Money(amount: self.amount * 2, currency: "USD")
            } else if (self.currency == "EUR") {
                return Money(amount: self.amount * 2/3, currency: "USD")
            } else if (self.currency == "CAN") {
                return Money(amount: self.amount * 4/5, currency: "USD")
            } else {
                return self
            }
        } else if (mon == "GBP") {
            if (self.currency == "USD") {
                return Money(amount: self.amount / 2, currency: "GBP")
            } else if (self.currency == "EUR") {
                return Money(amount: self.amount * 1/3, currency: "GBP")
            } else if (self.currency == "CAN") {
                return Money(amount: self.amount * 2/5, currency: "GBP")
            } else {
                return self
            }
        }
        if (mon == "EUR") {
            if (self.currency == "USD") {
                return Money(amount: self.amount * 3/2, currency: "EUR")
            } else if (self.currency == "GBP") {
                return Money(amount: self.amount * 3, currency: "EUR")
            } else if (self.currency == "CAN") {
                return Money(amount: self.amount * 6/5, currency: "EUR")
            } else {
                return self
            }
        }
        if (mon == "CAN") {
            if (self.currency == "USD") {
                return Money(amount: self.amount * 5/4, currency: "CAN")
            } else if (self.currency == "EUR") {
                return Money(amount: self.amount * 5/2, currency: "CAN")
            } else if (self.currency == "GBP") {
                return Money(amount: self.amount * 5/6, currency: "CAN")
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    public func add(_ mon : Money) -> Money {
        return Money(amount: self.convert(mon.currency).amount + mon.amount, currency: mon.currency)
    }
    
    public func subtract(_ mon : Money) -> Money {
        return Money(amount: mon.amount - self.convert(mon.currency).amount, currency: mon.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    
    var title : String
    var type : JobType

    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }

    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }

    public func calculateIncome(_ job : Int) -> UInt {
        switch self.type {
        case .Hourly(let val) :
               return UInt(val * Double(job))

        case .Salary(let val) :
                return UInt(val)
        }
    }
    
    public func raise(byAmount val: Double) {
        switch type {
        case .Hourly(let res) :
            self.type = JobType.Hourly(res + val)
        case .Salary(let res) :
            self.type = JobType.Salary(UInt(res + UInt(val)))
        }
    }
    
    public func raise(byPercent val: Double) {
        switch type {
        case .Hourly(let res) :
            self.type = JobType.Hourly(res + (res * val))
        case .Salary(let res) :
            self.type = JobType.Salary(UInt(res +  (res * UInt(val * 10))/10))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName : String
    var lastName : String
    var age : Int
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    var _job : Job? = nil
    var job : Job? {
        get {
            return self._job;
        }
        set(value) {
            if(self.age >= 16) {
                self._job = value;
            } else {
                self._job = nil;
            }
        }
    }
    
    var _spouse : Person? = nil
    var spouse : Person? {
        get {
            return self._spouse;
        }
        set(value) {
            if(self.age >= 21) {
                self._spouse = value;
            } else {
                self._spouse = nil;
            }
        }
    }
    

    func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self._job)) spouse:\(String(describing: self._spouse))]"
      }
    
    
    
}

////////////////////////////////////
// Family
//
public class Family {
    var members : [Person] = []

    init(spouse1: Person, spouse2: Person) {
        if(spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.members.append(spouse1)
            self.members.append(spouse2)
        }
    }

    func haveChild(_ child: Person) -> Bool {
        for member in self.members {
               if(member.age >= 21 && member.spouse != nil) {
                   self.members.append(child);
                   return true;
               }
           }
        return false;
    }

    func householdIncome() -> Int {
        var res = 0;
        for member in self.members {
            if(member.job != nil) {
                res += Int((member.job?.calculateIncome(2000))!)
            }
        }
        return res
    }
}
