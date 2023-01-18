module UserApi
  module V1
    class SleepRecords < Grape::API
      resources :sleep_records do
        before { authenticate! }

        desc '用來測試服務是否活著'
        get :ping do
          { data: { now: Time.zone.now.iso8601 } }
        end

        desc 'create sleep record'
        params do
          requires :start_at, type: DateTime, desc: 'sleep start at'
          requires :end_at,   type: DateTime, desc: 'sleep end at'
        end
        post '/' do
          if current_user.sleep_records.overlap(params[:start_at])
                         .or(current_user.sleep_records.overlap(params[:end_at])).exists?
            error!('sleep record time overlap', 422)
          end

          create_attrs = params.slice(:start_at, :end_at)
          record = current_user.sleep_records.new(create_attrs)

          if record.save
            present record, with: Entities::SleepRecord
          else
            error!('sleep record create error', 422)
          end
        end

        desc 'get sleep records'
        get '/' do
          records = current_user.sleep_records

          present records, with: Entities::SleepRecord
        end

        desc 'get sleep record'
        get '/:id' do
          record = current_user.sleep_records.find(params[:id])

          present record, with: Entities::SleepRecord
        end

        desc 'update sleep record'
        params do
          optional :start_at, type: DateTime, desc: 'sleep start at'
          optional :end_at,   type: DateTime, desc: 'sleep end at'
        end
        put '/:id' do
          record = current_user.sleep_records.find(params[:id])

          update_attrs = params.slice(:start_at, :end_at)
          record.assign_attributes(update_attrs)

          if record.save
            present record, with: Entities::SleepRecord
          else
            error!('sleep record update error', 422)
          end
        end

        desc 'delete sleep record'
        delete '/:id' do
          record = current_user.sleep_records.find(params[:id])

          if record.destroy
            { data: { success: true } }
          else
            error!('sleep record delete error', 422)
          end
        end
      end
    end
  end
end
