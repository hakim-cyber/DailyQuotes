//
//  FullQuote.swift
//  DailyQuotes
//
//  Created by aplle on 4/16/23.
//

import SwiftUI

struct FullQuote: View {
    let quote:Quote
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .leading){
            Text(quote.quote)
                .font(.largeTitle)
            
            Text(quote.author)
                .foregroundColor(.yellow)
                .font(.headline)
                .padding(20)
            
        }
        .padding(30)

        
        
    }
}

struct FullQuote_Previews: PreviewProvider {
    static var previews: some View {
        FullQuote(quote: Quote(quote: "HdJSDJSHDJSDJSJSdsskdksdkjskdjskjdksjdksjkdjkj", author: "Hakim", category: "Auye"))
    }
}
