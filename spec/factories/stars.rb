FactoryBot.define do
  factory :star do
    factory :alpha_cygni do
      identifier { '* alf Cyg' }
      coordinates { SphericalEquatorialCoordinates.parse('20 41 25.91514 +45 16 49.2197') }
      visual_magnitude { 1.25 }
      spectral_type { 'A2Ia' }
      object_type { 'sg*' }
    end

    factory :alpha_eridani do
      identifier { '* alf Eri' }
      coordinates { SphericalEquatorialCoordinates.parse('01 37 42.84548 -57 14 12.3101') }
      visual_magnitude { 0.46 }
      spectral_type { 'B6Vpe' }
      object_type { 'Be*' }
    end

    factory :beta_persei do
      identifier { '* bet Per' }
      coordinates { SphericalEquatorialCoordinates.parse('03 08 10.1324535  +40 57 20.328013') }
      visual_magnitude { 5.0 }
      spectral_type { 'B8V' }
      object_type { 'Al*' }
    end

    factory :betelgeuse do
      identifier { '* alf Ori' }
      coordinates { SphericalEquatorialCoordinates.parse('05 55 10.30536  +07 24 25.4304') }
      visual_magnitude { 0.42 }
      spectral_type { 'M1-M2Ia-Iab' }
      object_type { 's*r' }
    end

    factory :gamma_cassiopeiae do
      identifier { '* gam Cas' }
      coordinates { SphericalEquatorialCoordinates.parse('00 56 42.5317 +60 43 00.265') }
      visual_magnitude { 2.39 }
      spectral_type { 'B0.5IVpe' }
      object_type { 'Be*' }
    end
  end
end
