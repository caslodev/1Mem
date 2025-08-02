import { Button, Heading, Text } from "react-aria-components";

function App() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-50 via-secondary-50 to-accent-50 flex items-center justify-center p-8 font-display">
      <div className="text-center space-y-8 animate-fade-in">
        <div className="space-y-4 animate-slide-up">
          <Heading
            level={1}
            className="text-6xl font-bold bg-gradient-primary bg-clip-text text-transparent animate-bounce-gentle"
          >
            Hello World
          </Heading>

          <Text className="text-xl text-secondary-700 font-body max-w-md mx-auto leading-relaxed">
            Welcome to React Aria Components with custom Tailwind design tokens
          </Text>
        </div>

        <div className="space-y-6">
          <div className="flex flex-wrap justify-center gap-4">
            <Button
              className="px-8 py-4 bg-primary-600 text-white rounded-2xl hover:bg-primary-700 focus:outline-none focus:ring-4 focus:ring-primary-300 focus:ring-offset-2 shadow-soft hover:shadow-medium transition-all duration-400 font-semibold text-lg"
              onPress={() => alert("Hello from React Aria!")}
            >
              Primary Action
            </Button>

            <Button
              className="px-8 py-4 bg-secondary-600 text-white rounded-2xl hover:bg-secondary-700 focus:outline-none focus:ring-4 focus:ring-secondary-300 focus:ring-offset-2 shadow-soft hover:shadow-medium transition-all duration-400 font-semibold text-lg"
              onPress={() => alert("Secondary action!")}
            >
              Secondary
            </Button>

            <Button
              className="px-8 py-4 bg-accent-600 text-white rounded-2xl hover:bg-accent-700 focus:outline-none focus:ring-4 focus:ring-accent-300 focus:ring-offset-2 shadow-soft hover:shadow-glow transition-all duration-400 font-semibold text-lg"
              onPress={() => alert("Accent action!")}
            >
              Accent
            </Button>
          </div>

          <div className="flex justify-center space-x-4">
            <div className="w-4 h-4 bg-success-500 rounded-full animate-pulse-slow"></div>
            <div
              className="w-4 h-4 bg-warning-500 rounded-full animate-pulse-slow"
              style={{ animationDelay: "0.5s" }}
            ></div>
            <div
              className="w-4 h-4 bg-error-500 rounded-full animate-pulse-slow"
              style={{ animationDelay: "1s" }}
            ></div>
          </div>
        </div>

        <div className="mt-12 p-6 bg-white/80 backdrop-blur-sm rounded-3xl shadow-large border border-white/20">
          <Text className="text-secondary-600 font-mono text-sm">
            Built with ❤️ using React Aria Components + Tailwind CSS
          </Text>
        </div>
      </div>
    </div>
  );
}

export default App;
