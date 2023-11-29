#include <boost/ut.hpp>
#include <eigen3/Eigen/Core>
#include <eigen3/Eigen/Dense>
#include <fmt/format.h>
#include <juce_core/juce_core.h>
#include <numeric>
#include <range/v3/numeric/accumulate.hpp>
#include <range/v3/view/iota.hpp>
#include <range/v3/view/take.hpp>
#include <range/v3/view/transform.hpp>

constexpr auto sum(auto... values) { return (values + ...); }

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
    Eigen::Matrix3f m;
    m << 1, 2, 3, 4, 5, 6, 7, 8, 9;

    expect(eq(m(3, 3), 9));
  };
}
