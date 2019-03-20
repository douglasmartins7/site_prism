# frozen_string_literal: true

describe SitePrism::ElementChecker do
  # This stops the stdout process leaking between tests
  before(:each) { wipe_logger! }

  shared_examples 'a page' do
    describe '#all_there?' do
      subject { page.all_there? }

      context 'by default' do
        it { is_expected.to be true }

        it 'checks only the expected elements' do
          expect(page).to receive(:there?).with(:element_one).once
          expect(page).not_to receive(:there?).with(:element_two)

          subject
        end
      end

      context 'with recursion set to none' do
        subject { page.all_there?(recursion: 'none') }

        it { is_expected.to be true }

        it 'checks only the expected elements' do
          expect(page).to receive(:there?).with(:element_one).once
          expect(page).not_to receive(:there?).with(:element_two)

          subject
        end
      end

      context 'with recursion set to one' do
        subject { page.all_there?(recursion: 'one') }

        it { is_expected.to be true }

        it 'checks only the expected elements' do
          expect(page).to receive(:there?).with(:element_one).once
          expect(page).not_to receive(:there?).with(:element_two)

          subject
        end
      end

      context 'with recursion set to an invalid value' do
        subject { page.all_there?(recursion: 'go nuts') }

        it 'does not check any elements' do
          expect(page).not_to receive(:there?)

          subject
        end

        it 'sends an error to the SitePrism logger' do
          log_messages = capture_stdout do
            SitePrism.configure { |config| config.log_level = :DEBUG }
            subject
          end

          expect(lines(log_messages)).to eq(2)
        end
      end
    end

    describe '#elements_present' do
      it 'lists the SitePrism objects that are present on the page' do
        expect(page.elements_present).to eq(%i[element_one element_three])
      end
    end
  end

  context 'on a CSS Page' do
    let(:page) { CSSPage.new }
    let(:klass) { CSSPage }

    it_behaves_like 'a page'
  end

  context 'on an XPath Page' do
    let(:page) { XPathPage.new }
    let(:klass) { XPathPage }

    it_behaves_like 'a page'
  end
end
