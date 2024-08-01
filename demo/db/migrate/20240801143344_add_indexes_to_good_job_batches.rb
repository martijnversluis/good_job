# frozen_string_literal: true

class AddIndexesToGoodJobBatches < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    reversible do |dir|
      dir.up do
        return if connection.index_name_exists?(:good_job_batches, :index_good_job_batches_for_cleanup)
      end
    end

    add_index :good_job_batches, [:created_at, :id], name: "index_good_job_batches_for_display", algorithm: :concurrently
    add_index :good_job_batches, [:callbacks_finished_at, :discarded_at], order: { callbacks_finished_at: :asc, discarded_at: "ASC NULLS LAST" },
      where: "(callbacks_finished_at IS NOT NULL)", name: "index_good_job_batches_for_cleanup", algorithm: :concurrently
  end
end
