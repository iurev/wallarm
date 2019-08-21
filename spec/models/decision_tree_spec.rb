require 'rails_helper'

RSpec.describe DecisionTree, type: :model do
  describe '.construct' do
    describe 'no actions' do
      let(:dt) { DecisionTree.construct }

      it do
        expect(dt.to_hash).to eq([])
      end
    end

    describe 'one action' do
      describe 'one key' do
        let!(:action) do
          create(:action, properties: {
            color: 'green'
          })
        end
        let(:dt) { DecisionTree.construct }

        it do
          expect(dt.to_hash).to eq({
            key: 'color',
            values: {
              green: [action.id],
            },
            default: []
          })
        end
      end

      describe 'two keys' do
        let!(:action) do
          create(:action, properties: {
            color: 'green',
            location: 'Moscow'
          })
        end
        let(:dt) { DecisionTree.construct }

        it do
          expect(dt.to_hash).to eq({
            key: 'color',
            values: {
              green: {
                key: 'location',
                values: {
                  'Moscow': [action.id],
                },
                default: []
              }
            },
            default: []
          })
        end
      end

      describe 'three keys' do
        let!(:action) do
          create(:action, properties: {
            color: 'green',
            location: 'Moscow',
            real: 'yes'
          })
        end
        let(:dt) { DecisionTree.construct }

        it do
          expect(dt.to_hash).to eq({
            key: 'color',
            values: {
              green: {
                key: 'location',
                values: {
                  'Moscow': {
                    key: 'real',
                    values: {
                      yes: [action.id]
                    },
                    default: []
                  }
                },
                default: []
              }
            },
            default: []
          })
        end
      end
    end

    describe 'two actions' do
      describe 'same key' do
        describe 'same values' do
          let!(:action1) do
            create(:action, properties: {
              color: 'green'
            })
          end
          let!(:action2) do
            create(:action, properties: {
              color: 'green'
            })
          end
          let(:dt) { DecisionTree.construct }

          it do
            expect(dt.to_hash).to eq({
              key: 'color',
              values: {
                green: [action1.id, action2.id],
              },
              default: []
            })
          end
        end

        describe 'differеnt values' do
          let!(:action1) do
            create(:action, properties: {
              color: 'green'
            })
          end
          let!(:action2) do
            create(:action, properties: {
              color: 'red'
            })
          end
          let(:dt) { DecisionTree.construct }

          it do
            expect(dt.to_hash).to eq({
              key: 'color',
              values: {
                green: [action1.id],
                red: [action2.id],
              },
              default: []
            })
          end
        end
      end

      describe 'two different keys' do
        let!(:action1) do
          create(:action, properties: {
            color: 'green'
          })
        end
        let!(:action2) do
          create(:action, properties: {
            city: 'Moscow'
          })
        end
        let(:dt) { DecisionTree.construct }

        it do
          expect(dt.to_hash).to eq({
            key: 'color',
            values: {
              green: [action1.id],
            },
            default: {
              key: 'city',
              values: {
                Moscow: [action2.id],
              },
              default: []
            }
          })
        end
      end

      describe 'same keys, same values, but +1 key' do
        let!(:action1) do
          create(:action, properties: {
            color: 'green'
          })
        end
        let!(:action2) do
          create(:action, properties: {
            color: 'green',
            city: 'Moscow'
          })
        end
        let(:dt) { DecisionTree.construct }

        it do
          expect(dt.to_hash).to eq({
            key: 'color',
            values: {
              green: {
                key: 'city',
                values: {
                  Moscow: [action2.id]
                },
                default: [action1.id]
              }
            },
            default: []
          })
        end
      end

      describe 'same keys, same values, but +1 key, another order' do
        let!(:action1) do
          create(:action, properties: {
            color: 'green',
            city: 'Moscow'
          })
        end
        let!(:action2) do
          create(:action, properties: {
            color: 'green',
            city: 'Moscow'
          })
        end
        let(:dt) { DecisionTree.construct }

        it do
          expect(dt.to_hash).to eq({
            key: 'city',
            values: {
              Moscow: {
                key: 'color',
                values: {
                  green: [action1.id, action2.id]
                },
                default: []
              }
            },
            default: []
          })
        end
      end
    end

    describe 'example #1 from pdf' do
      let!(:action1) do
        create(:action, properties: {
          color: 'green',
          location: 'unknown'
        })
      end
      let!(:action2) do
        create(:action, properties: {
          color: 'red',
          real: 'no'
        })
      end
      let!(:action3) do
        create(:action, properties: {
          location: 'Moscow'
        })
      end
      let(:dt) { DecisionTree.construct }

      it do
        expect(dt.to_hash).to eq({
          key: 'color',
          values: {
            green: {
              key: 'location',
              values: {
                unknown: [action1.id]
              },
              default: []
            },
            red: {
              key: 'real',
              values: {
                no: [action2.id]
              },
              default: []
            }
          },
          default: {
            key: 'location',
            values: {
              Moscow: [action3.id]
            },
            default: []
          }
        })
      end
    end

    describe 'example #2' do
      let!(:action1) do
        create(:action, properties: {
          v: '1',
          v2: '2'
        })
      end
      let!(:action2) do
        create(:action, properties: {
          value: 'moscow',
        })
      end
      let!(:action3) do
        create(:action, properties: {
          value: 'asdf'
        })
      end
      let!(:action4) do
        create(:action, properties: {
          value: 'asdf2'
        })
      end
      let(:dt) { DecisionTree.construct }

      it do
        expect(dt.to_hash).to eq({
          key: 'v',
          values: {
            "1": {
              key: 'v2',
              values: {
                "2": [action1.id]
              },
              default: []
            },
          },
          default: {
            key: 'value',
            values: {
              moscow: [action2.id],
              asdf: [action3.id],
              asdf2: [action4.id],
            },
            default: []
          }
        })
      end
    end

    describe 'strange keys' do
      describe 'Ktulkhu' do
        let!(:action) do
          create(:action, properties: {
            name: 'kəˈtuːluː'
          })
        end
        let(:dt) { DecisionTree.construct }

        it do
          expect(dt.to_hash).to eq({
            key: 'name',
            values: {
              'kəˈtuːluː': [action.id],
            },
            default: []
          })
        end
      end

      describe 'special symbols' do
        let!(:action) do
          create(:action, properties: {
            symbols: '\'~*^$@$@!'
          })
        end
        let(:dt) { DecisionTree.construct }

        it do
          expect(dt.to_hash).to eq({
            key: 'symbols',
            values: {
              '\'~*^$@$@!': [action.id],
            },
            default: []
          })
        end
      end

      describe 'emoji' do
        let!(:action) do
          create(:action, properties: {
            symbols: '❤️'
          })
        end
        let(:dt) { DecisionTree.construct }

        it do
          expect(dt.to_hash).to eq({
            key: 'symbols',
            values: {
              '❤️': [action.id],
            },
            default: []
          })
        end
      end

      describe 'numbers' do
        let!(:action) do
          create(:action, properties: {
            number: 1,
          })
        end
        let(:dt) { DecisionTree.construct }

        it do
          expect(dt.to_hash).to eq({
            key: 'number',
            values: {
              '1': [action.id],
            },
            default: []
          })
        end
      end
    end

    describe 'performance', :perf do
      describe '1000 records' do
        describe 'same name-value' do
          before(:each) do
            1000.times do |_|
              create(:action)
            end
          end
          let(:dt) { DecisionTree.construct }

          it { expect(dt).to be_kind_of(DecisionTree::Node) }
          it { expect(dt.to_hash).to be_kind_of(Hash) }
          it { expect { DecisionTree.construct }.to perform_under(50).ms }
        end

        describe 'same keys, different values' do
          before(:each) do
            1000.times do |i|
              create(:action, {
                properties: {
                  value: "v#{i}"
                }
              })
            end
          end
          let(:dt) { DecisionTree.construct }

          it { expect(dt).to be_kind_of(DecisionTree::Node) }
          it { expect(dt.to_hash).to be_kind_of(Hash) }
          it { expect { DecisionTree.construct }.to perform_under(50).ms }
        end

        describe 'different keys, different values' do
          before(:each) do
            1000.times do |i|
              properties = {}
              properties[:"value#{i + 1}"] = "v#{i}"
              create(:action, { properties: properties })
            end
          end
          let(:dt) { DecisionTree.construct }

          it { expect(dt).to be_kind_of(DecisionTree::Node) }
          it { expect(dt.to_hash).to be_kind_of(Hash) }
          it { expect { DecisionTree.construct }.to perform_under(300).ms }
        end
      end

      describe '5_000 records' do
        describe 'different keys, different values' do
          before(:each) do
            5_000.times do |i|
              properties = {}
              properties[:"value#{i + 1}"] = "v#{i}"
              create(:action, { properties: properties })
            end
          end
          let(:dt) { DecisionTree.construct }

          # 😕
          it { expect { DecisionTree.construct }.to perform_under(10_000).ms }
        end
      end
    end
  end
end
