module JobHelper
  def get_dh_id(tags_hash,dh_array_id)
    if (tags_hash[:docker_host_ip].to_s.strip.empty? )
      docker_host_id=Rails.configuration.docker_hosts[dh_array_id]
    else
      job_params[:DockerHostID]=params[:tags][:docker_host_ip].to_s
    end
  end
end
