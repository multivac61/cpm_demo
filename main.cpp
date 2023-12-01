#include "etl/numeric.h"
#include "etl/vector.h"
#include <Eigen/Core>
#include <Eigen/Dense>
#include <boost/sml.hpp>
#include <boost/ut.hpp>
#include <fmt/format.h>
#include <juce_core/juce_core.h>
#include <numeric>
#include <range/v3/numeric/accumulate.hpp>
#include <range/v3/view/iota.hpp>
#include <range/v3/view/take.hpp>
#include <range/v3/view/transform.hpp>

namespace sml = boost::sml;

constexpr auto sum(auto... values) { return (values + ...); }

struct sender {
  template <class TMsg> constexpr void send(const TMsg &msg) {
    std::printf("send: %d\n", msg.id);
  }
};

// Events
struct ack {
  bool valid{};
};
struct fin {
  int id{};
  bool valid{};
};
struct release {};
struct timeout {};

// Guards
constexpr auto is_valid = [](const auto &event) { return event.valid; };

// Actions
constexpr auto send_fin = [](sender &s) { s.send(fin{0}); };
constexpr auto send_ack = [](const auto &event, sender &s) { s.send(event); };

struct tcp_release {
  auto operator()() const {
    using namespace sml;
    /**
     * Initial state: *initial_state
     * Transition DSL: src_state + event [ guard ] / action = dst_state
     */
    return make_transition_table(
        *"established"_s + event<release> / send_fin = "fin wait 1"_s,
        "fin wait 1"_s + event<ack>[is_valid] = "fin wait 2"_s,
        "fin wait 2"_s + event<fin>[is_valid] / send_ack = "timed wait"_s,
        "timed wait"_s + event<timeout> = X);
  }
};

int main() {
  using namespace boost::ut;

  "sum"_test = [] {
    expect(sum(0) == 0_i);
    expect(sum(1, 2) == 3_i);
    expect(sum(1, 20) == 21_i);
  };

  "fmt"_test = [] {
    expect(fmt::format("{}", 42) == "42");
    expect(fmt::format("{} {}", "hello", "world") == "hello world");
  };

  "ranges"_test = [] {
    using namespace ranges;
    int sum = accumulate(views::ints(1, unreachable) |
                             views::transform([](int i) { return i * i; }) |
                             views::take(10),
                         0);
    expect(sum == 385);
  };

  "juce"_test = [] {
    using namespace juce;
    const juce::String s = "hello";
    expect(s.toStdString() == "hello");
  };

  "eigen"_test = [] {
    Eigen::Matrix3i m;
    m << 1, 2, 3, 4, 5, 6, 7, 8, 9;

    expect(eq(m(0, 0), 1));
    expect(eq(m(2, 2), 9));
  };

  using namespace sml;

  "sml"_test = [] {
    sender s{};
    sm<tcp_release> sm{s};
    expect(sm.is("established"_s));

    sm.process_event(release{});
    expect(sm.is("fin wait 1"_s));

    sm.process_event(ack{true});
    expect(sm.is("fin wait 2"_s));

    sm.process_event(fin{42, true});
    expect(sm.is("timed wait"_s));

    sm.process_event(timeout{});
    expect(sm.is(X));
  };

  "etl"_test = [] {
    // Declare the vector instances.
    etl::vector<int, 10> v1(10);
    etl::vector<int, 20> v2(20);
    etl::iota(v1.begin(), v1.end(), 0);
    etl::iota(v2.begin(), v2.end(), 10);

    expect(eq(v1.at(0), 0));
    expect(eq(v2.at(0), 10));
  };
}
