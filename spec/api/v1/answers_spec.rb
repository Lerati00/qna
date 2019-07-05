require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }
  let(:access_token) { create(:access_token) }
  
  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer_response) { json['answers'].first }
      let(:answer) { answers.first }

      before { get api_path, params: { question_id: question.id, access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'return all public fields' do
        %w[id body question_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end        
      end

      it 'return object author' do
        expect(answer_response['author']['id']).to eq answer.author.id
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_link, :with_file, :with_comment) }
    let(:api_path) { "/api/v1/answers/#{answer.id}"}

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { id: answer.id, access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return all public fields' do
        %w[id body question_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end        
      end

      it 'return object author' do
        expect(answer_response['author']['id']).to eq answer.author.id
      end

      describe 'links' do
        let(:link_response) { answer_response['links'].first }

        it 'return list of links' do
          expect(answer_response['links'].size).to eq answer.links.size
        end

        it 'return all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq answer.links.first.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment_response) { answer_response['comments'].first }

        it 'return list of comments' do
          expect(answer_response['comments'].size).to eq answer.comments.size
        end

        it 'return all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq answer.comments.first.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file_response) { answer_response['files'].first }
        let(:file) { answer.files.first }

        it 'return list of files' do
          expect(answer_response['files'].size).to eq answer.files.size
        end

        it 'returns  public fields' do
          expect(file_response['id']).to eq file.id
          expect(file_response['filename']).to eq file.filename.to_s
          expect(file_response['url']).to eq url_for(file)
        end
      end
    end
  end
end
