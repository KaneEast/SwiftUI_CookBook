import SwiftUI
struct ProgressViewStyleView: View {
  @State private var progressValue = 0.5
  var body: some View {
    ProgressView(value: progressValue)
      .progressViewStyle(CustomProgressViewStyle())
      .onAppear {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
          if progressValue < 1.0 {
            progressValue += 0.01
          } else {
            timer.invalidate()
          }
        }
      }
  }
}
struct CustomProgressViewStyle: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    VStack {
      ProgressView(value: configuration.fractionCompleted)
        .accentColor(configuration.fractionCompleted! < 1.0 ? .red : .blue)
      Text("\(Int((configuration.fractionCompleted ?? 0) * 100))%")
    }
  }
}
struct CircularProgressBar: View {
  @State private var progress: CGFloat = 0.2 // example progress value

  var body: some View {
    VStack {
      CircularProgressView(progress: progress)
        .frame(width: 200, height: 200) // adjust size as needed

      Slider(value: $progress, in: 0...1) // Slider to adjust progress for demonstration
        .padding()
    }
  }
}
struct CircularProgressView: View {
  let progress: CGFloat

  var body: some View {
    ZStack {
      // Background for the progress bar
      Circle()
        .stroke(lineWidth: 20)
        .opacity(0.1)
        .foregroundColor(.blue)

      // Foreground or the actual progress bar
      Circle()
        .trim(from: 0.0, to: min(progress, 1.0))
        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
        .foregroundColor(.blue)
        .rotationEffect(Angle(degrees: 270.0))
        .animation(.linear, value: progress)
    }
  }
}
struct DeterminateProgressBar: View {
  @State private var downloadProgress = 0.0
  @State private var timer: Timer? = nil

  var body: some View {
    VStack {
      ProgressView("Downloading...", value: downloadProgress, total: 100)
        .progressViewStyle(.linear)
      Button("Start Download") {
        simulateDownload()
      }
    }
  }

  func simulateDownload() {
    timer?.invalidate() // Cancel the previous timer if any
    downloadProgress = 0.0 // Reset the progress
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
      if downloadProgress < 100 {
        downloadProgress += 1.0
      } else {
        timer.invalidate()
      }
    }
  }
}
struct IndeterminateProgress: View {
  var body: some View {
    IndeterminateProgressView()
  }
}
struct IndeterminateProgressView: View {
  @State private var isLoading = true

  var body: some View {
    VStack {
      ProgressView("Loading…")
        .progressViewStyle(.circular)
        .scaleEffect(2.0, anchor: .center) // Optional: make it bigger
    }
    .onAppear {
      startAnimating()
    }
  }

  func startAnimating() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      withAnimation(Animation.linear(duration: 1.5).repeatForever()) {
        isLoading = true
      }
    }
  }
}
struct ProgressViewInNavigationBar: View {
  var body: some View {
    NavigationStack {
      VStack {
        Text("Hello, World!")
      }
      .navigationTitle("ProgressViewInNavigationBar")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          ProgressView()
          /*.progressViewStyle(LinearProgressViewStyle(tint: Color.blue))*/
          // .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))

        }
      }
    }
  }
}
struct CustomSegmentedProgressBar: View {
  @State private var progressOne: CGFloat = 0
  @State private var progressTwo: CGFloat = 0
  @State private var progressThree: CGFloat = 0

  var body: some View {
    VStack {
      GeometryReader { geometry in
        HStack(spacing: 0) {
          RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.green)
            .frame(height: 10)
            .frame(width: progressOne * geometry.size.width / 3)
          RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.blue)
            .frame(height: 10)
            .frame(width: progressTwo * geometry.size.width / 3)
          RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.purple)
            .frame(height: 10)
            .frame(width: progressThree * geometry.size.width / 3)
        }
        .frame(height: 50)
      }
      Button("Start Task") {
        withAnimation(.easeInOut(duration: 2)) {
          progressOne = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          withAnimation(.easeInOut(duration: 2)) {
            progressTwo = 1.0
          }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
          withAnimation(.easeInOut(duration: 2)) {
            progressThree = 1.0
          }
        }
      }
      .padding()
      Spacer()
    }
    .padding()
  }
}
struct CustomProgressView: View {
  let progress: CGFloat

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Rectangle()
          .frame(width: geometry.size.width, height: 10)
          .opacity(0.3)
          .foregroundColor(.gray)

        Rectangle()
          .frame(
            width: min(progress * geometry.size.width,
                       geometry.size.width),
            height: 10
          )
          .foregroundColor(.blue)
      }
    }
  }
}
struct CustomProgressViewViewer: View {
  @State var progress: CGFloat = 0.5

  var body: some View {
    VStack {
      CustomProgressView(progress: progress)
        .frame(height: 10)
        .padding(.horizontal, 50)

      Button(action: {
        progress += 0.1
      }) {
        Text("Increase Progress")
      }
    }
  }
}
#Preview {
  VStack(spacing: 10) {
    ProgressViewStyleView()
    CircularProgressBar()
    DeterminateProgressBar()
    IndeterminateProgress()
    ProgressViewInNavigationBar()
    CustomSegmentedProgressBar()
    CustomProgressViewViewer()
  }
}
