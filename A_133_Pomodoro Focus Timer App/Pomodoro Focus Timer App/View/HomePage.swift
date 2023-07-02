//
//  HomePage.swift
//  Pomodoro Focus Timer App
//
//  Created by work on 3/12/23.
//

import SwiftUI

struct HomePage: View {
   
    
    @EnvironmentObject var viewModel: FocusTimeViewModel
    
    var body: some View {
        VStack {
            Text("Pomodoro Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            GeometryReader { proxy in
                VStack(spacing: 15) {
                    ZStack{
                        Circle()
                            .fill(.white.opacity(0.03))
                            .padding(-40)
                        
                        Circle()
                            .trim(from: 0, to: viewModel.progress)
                            .stroke(.white.opacity(0.03), lineWidth: 80)
                            
                        
                        
                        // MARK: Shadow
                        Circle()
                            .stroke(Color("Purple").opacity(0.7), lineWidth: 5)
                            .blur(radius: 15)
                            .padding(-2)
                            
                        
                        Circle()
                            .fill(Color("BG"))
                            
                        
                        Circle()
                            .trim(from: 0, to: viewModel.progress)
                            .stroke(Color("Purple").opacity(0.7), lineWidth: 10)
                        
                        
                        // MARK: knob
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color("Purple"))
                                .frame(width: 30, height: 30)
                                .overlay(content: {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                })
                                .frame(width: size.width, height: size.height, alignment: .center)
                            // MARK: Since view is rotated thats why using x
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: viewModel.progress * 360))
                        }
                        
                        Text(viewModel.timerStringValue)
                            .font(.system(size: 45, weight: .light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: viewModel.progress)
                        
                        
                    }
                    .padding(60)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: viewModel.progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Button {
                        if viewModel.isStarted {
                            viewModel.stopTimer()
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }else {
                            viewModel.addNewTimer = true
                        }
                    } label: {
                        Image(systemName: !viewModel.isStarted ? "timer" : "stop.fill")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background {
                                Circle()
                                    .fill(Color("Purple"))
                            }
                            .shadow(color: Color("Purple"), radius: 8)
                    }

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding()
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .overlay(content: {
            ZStack {
                Color.black
                    .opacity(viewModel.addNewTimer  ? 0.25 : 0)
                    .onTapGesture {
                        viewModel.hour = 0
                        viewModel.seconds = 0
                        viewModel.minutes = 0
                        viewModel.addNewTimer = false
                    }
                NewTimerView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y : viewModel.addNewTimer ? 0 : 400)
            }.animation(.easeInOut, value: viewModel.addNewTimer)
        })
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if viewModel.isStarted {
                viewModel.updateTimer()
            }
        }
        .alert("Congratulations You did is hooray", isPresented: $viewModel.isFinished) {
            Button("Start New", role: .cancel) {
                viewModel.stopTimer()
                viewModel.addNewTimer = true
                
            }
            Button("Close", role: .destructive) {
                viewModel.stopTimer()
            }

        }
    }
    
    
    // MARK: New timer bottom sheet
    @ViewBuilder
    func NewTimerView() -> some View {
        VStack(spacing: 15) {
            Text("Add New Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
            
            HStack(spacing: 15) {
                Text("\(viewModel.hour) hr")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 12, hint: "hr") { value in
                            viewModel.hour = value
                        }
                    }
                    
                Text("\(viewModel.minutes) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "min") { value in
                            viewModel.minutes = value
                        }
                    }
                
                Text("\(viewModel.seconds) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "sec") { value in
                            viewModel.seconds = value
                        }
                    }
            }
            .padding(.top, 20)
            
            Button {
                viewModel.startTimer()
            } label: {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background {
                        Capsule()
                            .fill(Color("Purple"))
                    }
            }
            .padding(.top)
            .disabled(viewModel.seconds == 0)
            .opacity(viewModel.seconds == 0 ? 0.5 : 1)

        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("BG"))
                .ignoresSafeArea()
        }
    }
    
    
    
    // MARK: Reusable Context Menu Options
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClock:@escaping (Int) -> Void) -> some View{
        ForEach(0...maxValue, id: \.self) { value in
            Button("\(value) \(hint)") {
                onClock(value)
            }
        }
    }
    
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
