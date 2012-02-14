module Enchant
  # Handles enchant version number taken from VERSION file. 
  # The way Haml gem handles it's version.rb inspired me for creating this
  # file. 
  class Version

    # Returns a hash representing the version of enchant.
    # The `:major`, `:minor`, and `:patch` keys have their respective numbers as Fixnums.
    # The `:name` key has the name of the version.
    # The `:string` key contains a human-readable string representation of the version.
    # The `:number` key is the major, minor, and patch keys separated by periods.
    # If enchant is checked out from Git, the `:rev` key will have the revision hash.  
    # 
    # For example:
    #
    #     {
    #       :string => "0.1.4.160676a",
    #       :rev    => "160676ab8924ef36639c7e82aa88a51a24d16949",
    #       :number => "0.1.4",
    #       :major  => 0, :minor => 1, :patch => 4
    #     }
    # 
    # If a prerelease version of enchant is being used,
    # the `:string` and `:number` fields will reflect the full version
    # (e.g. `"1.0.beta.1"`), and the `:patch` field will be `-1`.
    #
    # A `:prerelease` key will contain the name of the prerelease (e.g. `"beta"`),
    # and a `:prerelease_number` key will contain the rerelease number.
    #
    # For example:
    #
    #     {
    #       :string => "1.0.beta.1",
    #       :number => "1.0.beta.1",
    #       :major => 1, :minor => 0, :patch => -1,
    #       :prerelease => "beta",
    #       :prerelease_number => 1
    #     }
    # 
    # @return [{Symbol => String/Fixnum}] The version hash  
    def self.version
      return @@version if defined?(@@version)
      if File.exists?('VERSION')
        numbers = File.read('VERSION').strip.split('.').map {|n| n =~ /^[0-9]+$/ ? n.to_i : n}
      end
      if File.exists?('../../VERSION')
        numbers = File.read('../../VERSION').strip.split('.').map {|n| n =~ /^[0-9]+$/ ? n.to_i : n}
      else
        numbers = [0, 0, 0]
      end
      @@version = {
        :major => numbers[0],
        :minor => numbers[1],
        :patch => numbers[2]
      }
      if numbers[3].is_a?(String)
        @@version[:patch] = -1
        @@version[:prerelease] = numbers[3]
        @@version[:prerelease_number] = numbers[4]
      end
      @@version[:number] = numbers.join('.')
      @@version[:string] = @@version[:number].dup
      
      rev = revision_number
      @@version[:rev] = rev
      unless rev[0] == ?(
        @@version[:string] << "." << rev[0...7]
      end
      
      @@version
    end

    def self.revision_number
      if File.exists?('REVISION')
        rev = File.read('REVISION').strip
        return rev unless rev =~ /^([a-f0-9]+|\(.*\))$/ || rev == '(unknown)'
      end

      return unless File.exists?('.git/HEAD')
      rev = File.read('.git/HEAD').strip
      return rev unless rev =~ /^ref: (.*)$/

        ref_name = $1
      ref_file = "./.git/#{ref_name}"
      info_file = "./.git/info/refs"
      return File.read(ref_file).strip if File.exists?(ref_file)
      return unless File.exists?(info_file)
      File.open(info_file) do |f|
        f.each do |l|
          sha, ref = l.strip.split("\t", 2)
          next unless ref == ref_name
          return sha
        end
      end
      return nil
    end

  end
end
