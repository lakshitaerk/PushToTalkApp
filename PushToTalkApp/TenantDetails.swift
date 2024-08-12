//
//  TenantDetails.swift
//  PushToTalkApp
//
//  Created by lakshita sodhi on 28/07/24.
//
import SwiftUI

struct TenantDetails: View {
@State private var showSheet = false
@State private var offset = CGSize.zero
@State private var sheetState: SheetState = .collapsed

enum SheetState {
case collapsed
case partiallyExpanded
case fullyExpanded
}

var body: some View {
ZStack {
// Background content (e.g., map)
MapView()
.edgesIgnoringSafeArea(.all)

VStack {
Spacer()

Button(action: {
withAnimation {
showSheet.toggle()
if showSheet {
    sheetState = .partiallyExpanded
} else {
    sheetState = .collapsed
}
}
}) {
Text("Show Bottom Sheet")
.padding()
.background(Color.blue)
.foregroundColor(.white)
.cornerRadius(8)
}
.padding()
}

// Bottom sheet overlay
if showSheet {
BottomSheetView()
.offset(y: getSheetOffset())
.gesture(
DragGesture()
    .onChanged { gesture in
        offset = gesture.translation
    }
    .onEnded { _ in
        withAnimation {
            handleDragEnd()
        }
    }
)
.transition(.move(edge: .bottom))
.animation(.spring())
}
}
}

private func getSheetOffset() -> CGFloat {
switch sheetState {
case .collapsed:
return UIScreen.main.bounds.height // Fully hidden
case .partiallyExpanded:
return UIScreen.main.bounds.height / 3
case .fullyExpanded:
return 0 // Fully visible
}
}

private func handleDragEnd() {
if offset.height > 150 {
// Dragging down
if sheetState == .fullyExpanded {
sheetState = .partiallyExpanded
} else if sheetState == .partiallyExpanded {
sheetState = .collapsed
showSheet = false
}
} else if offset.height < -150 {
// Dragging up
if sheetState == .partiallyExpanded {
sheetState = .fullyExpanded
}
}
offset = .zero
}
}


struct MapView: View {
var body: some View {
// Simulated map background
Color.green
.overlay(Text("Map View")
.foregroundColor(.white)
.font(.largeTitle))
}
}

struct BottomSheetView: View {
let reviews: [Review] = [
Review(name: "John Doe", profileImage: "person1", reviewText: "Great place, really enjoyed the ambiance and the food."),
Review(name: "Jane Smith", profileImage: "person2", reviewText: "Had a wonderful time. Would definitely visit again."),
Review(name: "Emily Johnson", profileImage: "person3", reviewText: "Not as expected, but still decent overall.")
]
var body: some View {
GeometryReader { geometry in
VStack {
Spacer()
VStack {
// Drag indicator
RoundedRectangle(cornerRadius: 3)
.frame(width: 40, height: 6)
.foregroundColor(.gray)
.padding()

// Wrapping the content in a ScrollView to make it scrollable
ScrollView {
VStack {
    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {

     
         Image(systemName: "person")
             .resizable()
             .scaledToFill()
             .frame(width: 50, height: 50)
             .clipShape(Circle())
             .overlay(Circle().stroke(Color.gray, lineWidth: 1))
             .shadow(radius: 2)
        VStack {
            
            HStack {
                Text("Italian Pizza House")
                    .font(.headline)
                    .bold()
                Spacer()
            }

            HStack {
                Text("Hicksville")
                    .foregroundColor(.gray)
                Text(".")
                    .bold()
                Text("0.3 mi")
                    .foregroundColor(.gray)
               Spacer()
            }
            Spacer()
        }

        Spacer()
        Button(action: {
            // Add your action here
        }) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.title3)
        
        }
        Text("4.1")

        Button(action: {
            // Add your action here
        }) {
            Image(systemName: "arrow.right")
                .foregroundColor(.blue)
                .font(.title3)
                .shadow(color: .gray, radius: 3, x: 5, y: 5)
        }
        .padding()
    }
    
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 10) {
            ForEach(1..<6) { index in
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 250)
                    .clipped()
                    .cornerRadius(8)
                    .shadow(radius: 3)
            }
        }
        .padding(.vertical)
    }
        
   

    Divider()
        .background(Color.gray)
        .frame(height: 1)

    Text("Italian Pizza is a vibrant community of just over 2200 people, rich in history, known for its quiet neighborhoods and is bustling in community pride.")
        .font(.subheadline)
        .padding(.vertical)

    HStack {
        Text("POPULAR FOR")
            .bold()
            .font(.headline)
            .foregroundColor(.gray)
            .padding([ .bottom, .trailing])
        Spacer()
    }

    ScrollView(.horizontal, showsIndicators: false) {
               HStack(spacing: 10) { // Adjust spacing between tags
                   TagView(text: "Halal Certified")
                   TagView(text: "Kids friendly")
                   TagView(text: "Parking")
                   TagView(text: "Food")
                   TagView(text: "Cafe")
               }
               .padding(.bottom)
               .padding(.top,2.0)
           }


    Divider()
        .background(Color.gray)
        .frame(height: 1)

    HStack {
        Text("MENU")
            .bold()
            .font(.headline)
            .foregroundColor(.gray)
            .padding(.vertical)
        Spacer()
    }

ScrollView(.horizontal, showsIndicators: false) {
HStack(spacing: 10) {
ForEach(1..<6) { index in
ZStack(alignment: .bottomTrailing) {
   // Image
   Image(systemName: "photo")
       .resizable()
       .aspectRatio(contentMode: .fill)
       .frame(width: 220, height: 150)
       .clipped()
       .cornerRadius(8)
       .shadow(radius: 3)
   
   // Overlay Text
   VStack(alignment: .trailing) {
       Text("Item \(index)")
           .font(.headline)
           .foregroundColor(.white)
       Text("$\(index * 10)")
           .font(.subheadline)
           .foregroundColor(.white)
   }
   .padding(8)
   .background(Color.black.opacity(0.7))
   .clipShape(RoundedRectangle(cornerRadius: 8))
}
}
}
.padding(.bottom)
}
    
//offers and rewards
    
    Divider()
        .background(Color.gray)
        .frame(height: 1)

    HStack {
        Text("OFFERS AND REWARDS")
            .bold()
            .font(.headline)
            .foregroundColor(.gray)
            .padding(.vertical)
        Spacer()
    }

ScrollView(.horizontal, showsIndicators: false) {
HStack(spacing: 10) {
ForEach(1..<4) { index in
ZStack(alignment: .bottomTrailing) {
   // Image
   Image(systemName: "photo")
       .resizable()
       .aspectRatio(contentMode: .fill)
       .frame(width: 80, height: 150)
       .clipped()
       .cornerRadius(8)
       .shadow(radius: 3)
   
   // Overlay Text
   VStack(alignment: .trailing) {
       Text("Item \(index)")
           .font(.headline)
           .foregroundColor(.white)
       Text("$\(index * 10)")
           .font(.subheadline)
           .foregroundColor(.white)
   }
   .padding(8)
   .background(Color.black.opacity(0.7))
   .clipShape(RoundedRectangle(cornerRadius: 8))
}
}
}
.padding(.bottom)
}
    
    
    Divider()
        .background(Color.gray)
        .frame(height: 1)

    
    
    HStack {
        Text("REVIEWS")
            .bold()
            .font(.headline)
            .foregroundColor(.gray)
            .padding(.vertical)
        Spacer()
    }
    
    ForEach(reviews) { review in
    ReviewView(review: review)
    }
    
    HStack() {
        Image(systemName: "link")
            .foregroundColor(.blue)
        Text("Website")
            .font(.headline)
            Spacer()
    }
           .padding()
}
.padding()
}
}
.frame(width: geometry.size.width, height: geometry.size.height)
.background(Color.white)
.cornerRadius(20)
.shadow(radius: 20)
.padding(.bottom, 8.0)
}
}
.edgesIgnoringSafeArea(.bottom)
}
}
struct Review: Identifiable {
let id = UUID()
let name: String
let profileImage: String
let reviewText: String
}

struct ReviewView: View {
var review: Review

var body: some View {
VStack(alignment: .leading, spacing: 4) {
Text(review.reviewText)
.font(.body)


HStack(alignment: .center, spacing: 8) {
Image(review.profileImage)
.resizable()
.scaledToFill()
.frame(width: 30, height: 30)
.clipShape(Circle())
.overlay(Circle().stroke(Color.gray, lineWidth: 1))
.shadow(radius: 2)

VStack(alignment: .leading, spacing: 2) {
Text(review.name)
.font(.footnote)

Text("from Google")
.font(.footnote)
.foregroundColor(.gray)
}
}
}
.padding(.vertical, 4) // Uniform vertical padding
.padding(.horizontal) // Horizontal padding
}
}





struct TagView: View {
var text: String

var body: some View {
Text(text)
.font(.subheadline)
.padding(.vertical, 5)
.padding(.horizontal, 10)
.background(Color.purple.opacity(0.1))
.foregroundColor(.purple)
.cornerRadius(10)
.overlay(
RoundedRectangle(cornerRadius: 10)
.stroke(Color.purple, lineWidth: 1)
)
}
}

#Preview {
TenantDetails()
}
