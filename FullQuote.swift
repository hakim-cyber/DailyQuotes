//
//  FullQuote.swift
//  DailyQuotes
//
//  Created by aplle on 4/16/23.
//

import SwiftUI

struct FullQuote: View {
    let quote:IdentifiableQuote
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Text(quote.quote)
                    .font(.largeTitle)
                
                Text(quote.author)
                    .foregroundColor(.yellow)
                    .font(.headline)
                    .padding(20)
                HStack(){
                    Spacer()
                    let text = "❝\(quote.quote)❞ \n \n ✍️ \(quote.author) "
                    ShareLink(item:text)
                        
                    Spacer()
                }
                
            }
            .padding(30)
            .toolbar{
                Button("Done"){
                    dismiss()
                }
            }
            
        }
        
    }
        
}

struct FullQuote_Previews: PreviewProvider {
   
    static var previews: some View {
        @Environment(\.colorScheme) var colorScheme
        FullQuote(quote:IdentifiableQuote(quote: "HdJSDJSHDJSDJSJSdsskdksdkjskdjskjdksjdksjkdjkj", author: "Hakim", category: "Auye"))
            .preferredColorScheme(colorScheme == .light ? .dark : .light)
                
        
    }
}
