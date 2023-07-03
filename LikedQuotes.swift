//
//  LikedQuotes.swift
//  DailyQuotes
//
//  Created by aplle on 4/16/23.
//

import SwiftUI

struct LikedQuotes: View {
   
 @State var quotes = [IdentifiableQuote]()
    @State var searchText = ""
    @Environment(\.colorScheme) var colorScheme
    @State private var showingFull = false
    @State var selectedQuote:IdentifiableQuote?
    @State var howfilter = "author"

    
    let columns = [
        GridItem(.adaptive(minimum: 170))
    ]
    var quoteFilteredByAuthor:[IdentifiableQuote]{
        if searchText.isEmpty{
            return quotes
        }else{
            if howfilter == "author"{
                return quotes.filter{$0.author.localizedCaseInsensitiveContains(searchText)}
            }else{
                return quotes.filter{$0.quote.localizedCaseInsensitiveContains(searchText)}
            }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                SearchBar(text: $searchText,filter: $howfilter)
                    .padding(20)
            ScrollView{
                LazyVGrid(columns: columns){
                    ForEach(quoteFilteredByAuthor){quote in
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
                        }.padding(5)
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
                
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal,10)
           
        }
            
        }
        .phoneOnlyNavigationView()
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




struct SearchBar: View {
    
    @Binding var text: String
    @Binding var filter:String
    
  let filters = ["author","prompt"]
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Picker("Filter", selection: $filter){
                    ForEach(filters,id: \.self){type in
                        Text("By \(type.uppercased())")
                    }
                }
                .pickerStyle(.automatic)
            }
        HStack {
            TextField("Search ", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            
            Button(action: {
                text = ""
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            })
        }
    }
    }
}
