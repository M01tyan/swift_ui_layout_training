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
                .padding()
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
    enum Signal: String, CaseIterable, Identifiable {
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
    
    @State var colorPickers: [SignalColor] = [.消, .消, .消, .消]

    let signalLights: [[SignalColor]] = [
        [.黄, .消],        // 灯1
        [.赤, .消],        // 灯2
        [.緑, .消],        // 灯3
        [.緑, .黄, .消],   // 灯4
    ]
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .center) {
                    ForEach (colorPickers) { picker in
                        light
                            .foregroundColor(picker.color)
                    }
                }.frame(maxWidth: .infinity)
            }
            Section {
                Text(call?.rawValue ?? "--------")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity)
            }
            Section {
                ForEach (0..<signalLights.count, id: \.self) { index in
                    let signalColors: [SignalColor] = signalLights[index]
                    HStack {
                        Text("灯\(index + 1)")
                        Spacer()
                        Picker("灯\(index + 1)", selection: $colorPickers[index]) {
                            ForEach (signalColors) { signal in
                                Text(signal.rawValue).tag(signal)
                            }
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                }
            }
        }
        .navigationTitle("出発信号機")
    }
    
    var light: some View {
        Image(systemName: "circle.fill")
            .font(.largeTitle)
    }
    
    var call: Signal? {
        switch colorPickers {
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
            .previewDevice("iPhone 13")
    }
}
