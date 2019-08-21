require 'rails_helper'

RSpec.describe DecisionTree, type: :model do
  describe '.new' do
    let(:dt) do
      dt = DecisionTree.new
      dt.key = 'color'
      dt.default = DecisionTree.new
      dt
    end
    it { expect(dt.key).to eq('color') }
    it { expect(dt.values).to be_kind_of(DecisionTree::Values) }
    it { expect(dt.default).to be_kind_of(DecisionTree) }
  end

  describe '.construct' do
    describe 'no actions' do
      let(:dt) { DecisionTree.construct }

      it do
        expect(dt.to_h).to eq([])
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
          expect(dt.to_h).to eq({
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
          expect(dt.to_h).to eq({
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

        pending 'Implement choosing consistent key'
        it do
          expect(dt.to_h).to eq({
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
            expect(dt.to_h).to eq({
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
            expect(dt.to_h).to eq({
              key: 'color',
              values: {
                green: [action1.id],
                red:  [action2.id],
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
          expect(dt.to_h).to eq({
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
          expect(dt.to_h).to eq({
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
          expect(dt.to_h).to eq({
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

    describe 'example from pdf' do
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
        expect(dt.to_h).to eq({
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

    describe 'strange keys' do
      describe 'Ktulkhu' do
        let!(:action) do
          create(:action, properties: {
            name: 'kəˈtuːluː'
          })
        end
        let(:dt) { DecisionTree.construct }

        it do
          expect(dt.to_h).to eq({
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
          expect(dt.to_h).to eq({
            key: 'symbols',
            values: {
              '\'~*^$@$@!': [action.id],
            },
            default: []
          })
        end
      end
    end
  end
end
