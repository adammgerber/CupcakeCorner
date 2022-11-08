//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Adam Gerber on 08/11/2022.
//

import SwiftUI

class User: ObservableObject, Codable {
    @Published var name = "Paul Hudson"
    enum CodingKeys: CodingKey {
        case name
    }
    
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
}


struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
