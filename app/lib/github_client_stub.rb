def repos
  [
    OpenStruct.new(
      id: 123,
      name: "test-repo",
      full_name: "testuser/test-repo",
      language: "Ruby",
      clone_url: "https://github.com/testuser/test-repo.git",
      ssh_url: "git@github.com:testuser/test-repo.git"
    ),
    OpenStruct.new(
      id: 345,
      name: "hexlet-cv",
      full_name: "Hexlet/hexlet-cv",
      language: "Ruby",
      clone_url: "https://github.com/Hexlet/hexlet-cv.git",
      ssh_url: "git@github.com:Hexlet/hexlet-cv.git"
    ),
    OpenStruct.new(
      id: 999,
      name: "new-repo",
      full_name: "testuser/new-repo",
      language: "Ruby",
      clone_url: "https://github.com/testuser/new-repo.git",
      ssh_url: "git@github.com:testuser/new-repo.git"
    )
  ]
end
