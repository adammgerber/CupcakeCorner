//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Adam Gerber on 08/11/2022.
//

import SwiftUI


struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
//@Published does not conform to Codable
//name property is automatically wrapped in another type that adds functionality
//In this case that type is a struct : Published
//Published is a generic type, so you cant just make an instance of it...you need to add something like
//Published<String>: a publishable object that contains a string
class User: ObservableObject, Codable {
    @Published var name = "Paul Hudson"
    //enum CodingKeys that conforms to CodingKey( a swiftUI protocol)
    //we list all the properties we want to archive in this enum
    enum CodingKeys: CodingKey {
        case name
    }
    //custom initializer that will be given a container and used to read values for all our properties
    required init(from decoder: Decoder) throws{
        //we ask our Decoder instance for a container matching all the coding keys we already set in our CodingKey struct
        //  This means “this data should have a container where the keys match whatever cases we have in our CodingKeys enum
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //read values from container by referencing cases in enum
        //provides safety by making it clear we expect a string and nothing else
        //also provides safety by using a case in CodingKeys enum rather than a string, so no typos
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}


struct ContentView: View {
    
    @State private var results = [Result]()
    
    func loadData() async {
        
        //1. creating the URL we want to read
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song" ) else {
            print("Invalid URL")
            return
        }
        
        //2. fetch data from that URL
        do {
            //data(from:) takes a url and returns the DATA object of url (belongs to URLSession class)
            // we use the underscore next to data because we only care about data, not the metadata returned
            let (data, _) = try await URLSession.shared.data(from: url)
            //3. Convert the Data object into a Response using JSONDecoder and assign array to results
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from : data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
        
    }

    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading){
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
