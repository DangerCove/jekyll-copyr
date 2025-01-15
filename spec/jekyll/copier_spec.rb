# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jekyll::Copyr::Copier do
  before do
    Jekyll.logger.log_level = :error
  end

  after do
    if File.directory?(output_path)
      FileUtils.remove_dir output_path
    elsif File.file?(output_path)
      FileUtils.remove_dir File.dirname(output_path)
    end
  end

  let(:config) do
    { "tasks" => [{ "from" => input_path, "to" => output_path }] }
  end

  let(:disabled_config) do
    { "enabled" => false, "tasks" => [{ "from" => input_path, "to" => output_path }] }
  end

  context "when input_path is a directory" do
    let(:input_path) { File.expand_path "../fixtures/files/.", __dir__ }
    let(:output_path) { File.expand_path "../../tmp/copy", __dir__ }

    it "should copy files per default" do
      Jekyll::Copyr::Copier.new(config).process_post_write

      expect(File).to exist(File.join(output_path, "files", "0.txt"))
      expect(File).to exist(File.join(output_path, "files", "1.txt"))
      expect(File).to exist(File.join(output_path, "files", "2.txt"))
      expect(File).to exist(File.join(output_path, "files", "3.txt"))
    end

    it "should not copy files when disabled" do
      Jekyll::Copyr::Copier.new(disabled_config).process_post_write

      expect(File).not_to exist(File.join(output_path, "files", "0.txt"))
      expect(File).not_to exist(File.join(output_path, "files", "1.txt"))
      expect(File).not_to exist(File.join(output_path, "files", "2.txt"))
      expect(File).not_to exist(File.join(output_path, "files", "3.txt"))
    end
  end

  context "when input_path is a file" do
    let(:input_path) { File.expand_path "../fixtures/files/0.txt", __dir__ }
    let(:output_path) { File.expand_path "../../tmp/copy/files/0.txt", __dir__ }

    it "should copy a file" do
      Jekyll::Copyr::Copier.new(config).process_post_write
      expect(File).to exist(output_path)
      expect(Dir).not_to exist(output_path)
    end

    it "should not copy files when disabled" do
      Jekyll::Copyr::Copier.new(disabled_config).process_post_write
      expect(File).not_to exist(output_path)
    end
  end
end
