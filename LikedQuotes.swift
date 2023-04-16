//
//  LikedQuotes.swift
//  DailyQuotes
//
//  Created by aplle on 4/16/23.
//

import SwiftUI

struct LikedQuotes: View {
 @State var quotes = [IdentifiableQuote]()
    
    @Environment(\.colorScheme) var colorScheme
    @State private var showingFull = false
    @State var selectedQuote:IdentifiableQuote?
    
    let columns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: columns){
                    ForEach(quotes){quote in
                        ZStack{
                            Rectangle()
                                .frame(width: 170,height: 170)
                                .foregroundColor(colorScheme == .light ?  .black :.white)
                                .cornerRadius(30)
                            
                            VStack(alignment: .center, spacing: 2){
                                if showingFull{
                                    Text(" \(quote.quote)  ")
                                        .font(.largeTitle)
                                        .foregroundColor(colorScheme == .light ?  .white:.black)
                                    
                                    
                                    
                                }else{
                                    Text(" \(quote.quote ) ")
                                        .font(.headline)
                                        .foregroundColor(colorScheme == .light ?  .white :.black)
                                    
                                    
                                }
                                Text(quote.author)
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                    .padding(4)
                            }
                            .padding()
                        }
                        .scaledToFit()
                        .onTapGesture {
                            withAnimation {
                                selectedQuote = quote
                            }
                            
                            
                        }
                        
                    }
                }
                .onAppear(perform: loadLiked)
                
            }
            .sheet(item: $selectedQuote){quote in
                            FullQuote(quote: quote)
                    .preferredColorScheme(colorScheme == .light ? .dark : .light)
                        }
            
        }
    }
    
    func loadLiked(){
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "Liked"){
            if let decodedQuotes = try? decoder.decode([Quote].self, from: data){
                for quote in decodedQuotes{
                    let identifiableQuote = IdentifiableQuote(quote: quote.quote, author: quote.author, category: quote.category)
                    quotes.append(identifiableQuote)
                }
             
            }
        }
    }
}

struct LikedQuotes_Previews: PreviewProvider {
    static var previews: some View {
        LikedQuotes()
    }
}
