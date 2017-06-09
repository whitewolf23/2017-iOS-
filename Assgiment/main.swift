//
//  main.swift
//  Assgiment
//
//  Created by Myeongjin kyeong on 2017. 6. 8..
//  Copyright © 2017년 Myeongjin kyeong. All rights reserved.
//

import Foundation
//버림
extension Double{
    func round_number(_ dot:Int) -> Double{
        let divisor = pow(10.0, Double(dot))
        return (self * divisor).rounded() / divisor
    }
}
func gsno(_ value: String?) -> String{
    if let value_ = value{
        return value_
    }else{
        return ""
    }
}


func gdno(_ value: Double?) -> Double{
    if let value_ = value{
        return value_
    }else{
        return 0
    }
}


//학생
struct Student {
    //이름
    var name : String
    //평균
    var average : Double
    //학점
    var grade : String
    //합격 여부
    var pass: Bool
}

//과제
struct Subject {
    //데이타 불러올때. static 지정 안하면 key 값으로 불러올 수 가 없음.
    static let data_structure = "data_structure"
   static let algorithm = "algorithm"
    static let database = "database"
    static let operating_system = "operating_system"
    static let networking = "networking"
//     init(_ data_structure : String, _ algorithm : String,  _ database : String, _ operating_system : String, _ networking:String)
//    init(_ data_structure : String, _ algorithm : String,  _ database : String, _ operating_system : String, _ networking:String){
//        self.data_structure = data_structure
//        self.algorithm = algorithm
//        self.database = database
//        self.operating_system = operating_system
//        self.networking = networking

//    }

}

//전체 평균
func all_grade_average(_ scores : [Double]) -> Double{
    let count = Double(scores.count)
    let sum: Double
    sum = scores.reduce(0) {$0 + $1}
    print("++++\((sum / count).round_number(2))")

    return (sum / count).round_number(2)
    
}

//학점 나누기 
func separate_grade(_ score: Double) -> (String,Bool){
    switch score {
    case 90..<101:
        return ("A", true)
        
    case 80..<89:
        return ("B", true)
    case 70..<80:
        return ("C", true)
        
    case 60..<70:
        return ("D", false)
        
    default:
        return ("F", false)
        
    }
}//


//데이타 읽기
func get_json_data(_ path : FileManager.SearchPathDirectory, _ name: String) -> [Student]?{
    
    do{
        var students = [Student]()
        let fm = try! FileManager.default.url(for: path, in: .allDomainsMask, appropriateFor: nil, create: false)
        
        let fileName = "students"
        //        let fileUrl = fm.appendingPathComponent(fileName).appendingPathExtension("json")
        //        print(" 파일 디렉토리: \(fileUrl.path)")
        
        let json = fm.appendingPathComponent("\(name)/\(fileName).json")
        print(json)
        let data = try Data(contentsOf: json)
        
        let readJSON = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        //        print("json 내용 : \(readJSON )")
        
        for item in readJSON{
            let dic = item as! [String: Any]
            let student = bring_student_data(dic)
            if (student != nil) {
                print("정보가 존재하지 않습니다.")
            }else{
                continue
            }
            students.append(student!)
        }
        students.sort{ $0.0.name < $0.1.name}
        print("정보 : \(students)")
        
        return students
        
        
    }catch{
        print(error)
        return nil
        
    }
}//

// 학생 데이터 읽기
func bring_student_data(_ dic : [String:Any]) -> Student?{
    if let name = dic["name"] as? String,
        let grades = dic["grade"] as? [String: Any]{
        
      
        var total_grade = [Double]()
        
        
        for item in grades{
            switch item.key{
            case Subject.data_structure,
                 Subject.algorithm,
                 Subject.database,
                 Subject.networking,
                 Subject.operating_system :
            total_grade.append(gdno(item.value as? Double))
                
            default:
                break
            }
        }
       
        let average = all_grade_average(total_grade)
        let (grade, pass) = separate_grade(average)
       
//        print(Student(name: name, average: average, grade: grade, pass: pass))

        return Student(name: gsno(name), average: gdno(average), grade: gsno(grade), pass: pass)

    }
    return nil
}//







//결과물 만들기
func create_result(of students : [Student]) -> String{
    
    print(students)
    let average = all_grade_average(students.makeIterator().flatMap{$0.average})
   print(" 전체 평균 \(average)")
    var pass = [String]()
    
    var result = "성적 결과표 \n\n전체 평균 :\(average)\n\n개인별 학점 \n"
  
    for item in students{
        result.append("\(item.name)\t: \(item.grade) \n")
        print("\(item.name)\t: \(item.grade) \n")

        if item.pass{
            pass.append("\(item.name)")
            print("\(item.name)")
        }
    }

    result.append("\n수료생\n")
        result.append(pass.joined(separator: ","))
    
    return result
}//

    
    
    
    
//파일 생성
func create_file(_ path: FileManager.SearchPathDirectory, _ name : String , _ result: String){
  
    let fm = FileManager.default.urls(for: path , in: .allDomainsMask).first!
    
    let url = fm.appendingPathComponent("\(name)/result.txt")
    
    let data = result.data(using: .utf8, allowLossyConversion: false)!
    
    try! data.write(to: url, options: .atomic)
      
        

}//

func generate(){
//    let HomeUrl = NSHomeDirectory()
    let HomeUrl = "uiapp2012"
    let fileUrl = URL(fileURLWithPath: HomeUrl)
            print(" 파일 디렉토리: \(fileUrl.path)")

    let generate = get_json_data(.userDirectory, HomeUrl)
    
    if generate == nil{
        print("json data 없음")
    }
    
    let result = create_result(of: generate!)
    create_file(.userDirectory, HomeUrl, result)
}



////홈 디렉토리에 머기 있는지 파악
//let fm = FileManager.default
//let dirPath = "/Users/uiapp2012"
//let files = try? fm.contentsOfDirectory(atPath: dirPath)
//print("files : \(files)")

//데이터 읽기
//let fileName = "students"
//let HomeUrl = NSHomeDirectory()
//let fileUrl = URL(fileURLWithPath: HomeUrl)
//
generate()



