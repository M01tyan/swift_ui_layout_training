//
//  Topic003.swift
//  SwiftUIWeeklyLayoutChallenge
//
//  Created by treastrain on 2022/07/27.
//
import SwiftUI

/// <doc:Topic003>
public struct Topic003View: View {
    public init() {}
    
    public var body: some View {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            #if os(macOS)
            DepartureSignal()
            #else
            if #available(watchOS 7.0, *) {
                NavigationView {
                    DepartureSignal()
                }
            } else {
                DepartureSignal()
            }
            #endif
        } else {
            Text("Support for this platform is not considered.")
        }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct DepartureSignal: View {
    enum Signal: String, Equatable, Identifiable {
        /// 上の灯火から順に 消・消・緑・消 で進行信号を現示。
        case 出発進行
        /// 上の灯火から順に 黄・消・消・緑 で減速信号を現示。
        case 出発減速
        /// 上の灯火から順に 消・消・消・黄 で注意信号を現示。
        case 出発注意
        /// 上の灯火から順に 黄・消・消・黄 で警戒信号を現示。
        case 出発警戒
        /// 上の灯火から順に 消・赤・消・消 で停止信号を現示。
        case 出発停止
        
        var id: String { rawValue }

        static var allCases: [Signal] {
            return [.出発進行, .出発減速, .出発注意, .出発警戒, .出発停止]
        }

        var lightPattern: [SignalColor] {
            switch self {
            case .出発進行:
                return [.消, .消, .緑, .消]
            case .出発減速:
                return [.黄, .消, .消, .緑]
            case .出発注意:
                return [.消, .消, .消, .黄]
            case .出発警戒:
                return [.黄, .消, .消, .黄]
            case .出発停止:
                return [.消, .赤, .消, .消]
            }
        }
    }

    enum SignalColor: String, Equatable, Identifiable {
        case 黄
        case 赤
        case 緑
        case 消

        var color: Color {
            switch self {
            case .黄:
                return Color.yellow
            case .赤:
                return Color.red
            case .緑:
                return Color.green
            case .消:
                return Color.black
            }
        }

        var id: String { rawValue }
    }

    @State var signalPickers: [SignalColor] = [.消, .消, .消, .消]
    @State var callingSignal: Signal? = nil

    let signalLights: [[SignalColor]] = [
        [.黄, .消],        // 灯1
        [.赤, .消],        // 灯2
        [.緑, .消],        // 灯3
        [.緑, .黄, .消],   // 灯4
    ]

    var body: some View {
        Form {
            Section {
                VStack(alignment: .center) {
                    ForEach (signalPickers) { picker in
                        light
                            .foregroundColor(picker.color)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            Section {
                #if os(macOS) || os(tvOS)
                Picker("指差呼称", selection: $callingSignal) {
                    ForEach (Signal.allCases) { signal in
                        Text(signal.rawValue).tag(Signal?.some(signal))
                            .fixedSize()
                    }
                }
                .onChange(of: callingSignal) { newCallingSignal in
                    signalPickers = newCallingSignal?.lightPattern ?? signalPickers
                }
                #else
                Text(callingSignal?.rawValue ?? "--------")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity)
                #endif
            }
            Section {
                ForEach (0..<signalLights.count, id: \.self) { index in
                    let signalColors: [SignalColor] = signalLights[index]
                    HStack {
                        Text("灯\(index + 1)")
                        Spacer()
                        Picker("", selection: $signalPickers[index]) {
                            ForEach (signalColors) { signal in
                                Text(signal.rawValue).tag(signal)
                            }
                        }
                        .onChange(of: signalPickers[index]) { newValue in
                            callingSignal = call
                        }
                        .labelsHidden()
                        .fixedSize()
                        #if os(iOS) || os(tvOS)
                        .pickerStyle(.segmented)
                        #endif
                    }
                }
            }
        }
        .navigationTitle("出発信号機")
        #if os(macOS) || os(tvOS)
        .padding()
        #endif
    }

    var light: some View {
        Image(systemName: "circle.fill")
            .font(.largeTitle)
    }

    var call: Signal? {
        switch signalPickers {
        case [.消, .消, .緑, .消]:
            return .出発進行
        case [.黄, .消, .消, .緑]:
            return .出発減速
        case [.消, .消, .消, .黄]:
            return .出発注意
        case [.黄, .消, .消, .黄]:
            return .出発警戒
        case [.消, .赤, .消, .消]:
            return .出発停止
        default:
            return nil
        }
    }
}

struct Topic003View_Previews: PreviewProvider {
    static var previews: some View {
        Topic003View()
            .previewDevice(PreviewDevice(
//                rawValue: "Apple Watch Series 7 - 45mm"
//                rawValue: "Apple TV 4K"
//                rawValue: "Mac"
                rawValue: "iPhone 13"
            ))
    }
}
