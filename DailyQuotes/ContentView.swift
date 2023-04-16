//
//  ContentView.swift
//  DailyQuotes
//
//  Created by aplle on 4/10/23.
//

import SwiftUI
struct Quote:Codable,Hashable{
    
    let quote:String
    let author:String
    let category:String
    
}
struct IdentifiableQuote:Codable,Hashable,Identifiable{
    var id = UUID()
    let quote:String
    let author:String
    let category:String
    
}
struct HeartToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            withAnimation {
                configuration.isOn.toggle()
            }
           
        }) {
            Image(systemName: configuration.isOn ? "heart.fill" : "heart")
                .foregroundColor(configuration.isOn ? .red : .gray)
                .font(.system(size: 24))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ContentView: View {
    @State private var quote = [Quote]()
    @State var likedQuotes = [Quote]()
    @Environment(\.colorScheme) var colorScheme
    
    
    @State private var isShowingAuthor = false
    @State private var isShowingFull = false
    @State private var offset = CGSize.zero
    @State private var downloading = false
    @State private var isLiked = false
    
    var body: some View {
        NavigationView{
            
            ZStack{
                
                
                VStack(alignment: .center){
             
          
                    
                    
                   
                    ZStack{
                      
                        
                        RoundedRectangle(cornerRadius: 25,style: .continuous)
                            .fill( colorScheme == .light ?  .black .opacity(1 - Double(abs(offset.width / 50))) :.white
                                .opacity(1 - Double(abs(offset.width / 50))))
                           
                            .shadow(radius: 10)
                        
                        VStack{
                            if isShowingFull{
                                Text("❝ \(quote.first?.quote ?? "") test ❞ ")
                                    .font(.largeTitle)
                                    .foregroundColor(colorScheme == .light ?  .white:.black)
                                
                                
                                
                            }else{
                                Text(" ❝\(quote.first?.quote ?? "") ❞ ")
                                    .font(.largeTitle)
                                    .foregroundColor(colorScheme == .light ?  .white :.black)
                                
                                
                            }
                            if isShowingAuthor{
                                Text(quote.first?.author ?? "")
                                    .font(.title3)
                                    .foregroundColor(.yellow)
                                    .padding(0.5)
                            }
                            HStack{
                               
                                let text = "❝\(quote.first?.quote ?? "")❞ \n \n ✍️ \(quote.first?.author ?? "") "
                                ShareLink(item:text)
                                    .padding(0.5)
                           
                            }
                                
                        }
                        .opacity(1 - Double(abs(offset.width / 50)))
                        .padding()
                        .multilineTextAlignment(.center)
                        HStack{
                                                    if offset.width > 0 {
                                                        Image(systemName: "arrow.up.heart.fill")
                                                            .font(.largeTitle)
                                                            .clipShape(Circle())
                                                            .foregroundColor(.green)
                                                            .offset(x: -100,y:0)
                                                            
                                                    }
                                                    if offset.width < 0 {
                                                        Image(systemName: "gobackward")
                                                            .font(.largeTitle)
                                                            .foregroundColor(.red)
                                                            .offset(x: 110,y:0)
                                                    }
                                                }
                    }
                    .frame(width: isShowingFull ? 350 : 350 , height: isShowingFull ? 700 : 200)
                    .rotationEffect(.degrees(Double(offset.width / 5)))
                    .offset(x:offset.width * 5 ,y: 0)
                    .opacity(2 - Double(abs(offset.width / 50)))
                    .gesture(
                        DragGesture()
                            .onChanged{gesture in
                                
                                offset = gesture.translation
                            }
                            .onEnded{ _ in
                                if offset.width > 100 || offset.width < -100{
                                    
                                    if offset.width > 0{
                                        if let likedQuote = quote.first{
                                            likedQuotes.append(likedQuote)
                                            saveLiked()
                                            
                                        }
                                    }
                                    Task{
                                        
                                        if let retrievedQuote = await getQuotes(){
                                            withAnimation{
                                                if !quote.isEmpty{
                                                    quote.remove(at: 0)
                                                }
                                                
                                                quote = retrievedQuote
                                                offset.width = 0
                                                
                                                
                                            }
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }else{
                                    offset = .zero
                                }
                            }
                    )
                    .onTapGesture {
                        withAnimation{
                            isShowingAuthor.toggle()
                            isShowingFull.toggle()
                        }
                    }
                    
                    .animation(.easeIn, value: isShowingAuthor ? 100:0)
                    .scaledToFit()
                
              
                
            }
                
            
        }
            .toolbar{
                NavigationLink{
                    LikedQuotes()
                }label:{
                    Image(systemName: "heart.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                
            }
    }

            .navigationTitle("Quote of the day")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if let retrievedQuote = await getQuotes() {
                    withAnimation{
                        if !quote.isEmpty{
                            quote.remove(at: 0)
                        }
                        quote = retrievedQuote
                    }
                }
            }
    }

        
    func getQuotes()async ->[Quote]?{
        
       
        
        let url = URL(string: "https://api.api-ninjas.com/v1/quotes?category=inspirational")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("v8IZ75z4Ed+lrezJiJsFRg==zrGYqISrXc8vOrhx", forHTTPHeaderField: "X-Api-Key")
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decodedQuote = try JSONDecoder().decode([Quote].self, from: data)
            return decodedQuote
            
        }catch{
            print("Error")
        }
        
        return nil
        
    }
    func saveLiked(){
       let Encoder = JSONEncoder()
        if let encoded = try? Encoder.encode(likedQuotes){
            UserDefaults.standard.set(encoded, forKey: "Liked")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
